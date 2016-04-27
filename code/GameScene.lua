require "code/Paddle"
GameScene = Core.class(Sprite)

function GameScene:init()
  self.bodies = {}
  self.bodiesToRemove = {}
  self.bodiesAdded = 0
  self.ballUnderFloor = nil

  -- Load the background image.
  local bg = Bitmap.new(Texture.new("images/background.jpg", true))
  bg:setAnchorPoint(0.5, 0.5)
  bg:setPosition(CONFIG.width/2, CONFIG.height/2)
  self:addChild(bg)
  
  -- Load the texture pack.
  self.tex = TexturePack.new("texturepacks/GameScene.txt", "texturepacks/GameScene.png", true)
 
  -- Create the restart button.
  local restartText = TextField.new(CONFIG.fontMedium, "Restart")
  restartText:setTextColor(0xffff00)
  self.restartButton = Button.new(restartText)
  self.restartButton:setPosition(920, 200)
  self:addChild(self.restartButton)
  self.restartButton:addEventListener("click",
    function()
      SCENEMANAGER:changeScene("game", CONFIG.transitionTime, CONFIG.transition, CONFIG.easing)
	  
    end)
  
  -- Physics
  self.world = b2.World.new(0, 9.8, true)
  if CONFIG.debugDraw then
    local debugDraw = b2.DebugDraw.new()
    self.world:setDebugDraw(debugDraw)
    self:addChild(debugDraw)
  end
 
  -- World Boundary and Floor
  boundary = Boundary.new(self)
  self:addChild(boundary)
  floor = Floor.new(self)
  self:addChild(floor)
 
  -- Event Listeners for Physics events
  self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
  self.world:addEventListener(Event.POST_SOLVE, self.onPostSolve, self)

  -- Load the objects for the current level.
  local level = SETTINGS:get("currentLevel")
  local levelData = dataSaver.load("levels/"..level)
  self.bricksLeft = 0
  for i, value in ipairs(levelData) do
    if value.object == "paddle" then
	  local paddle = Paddle.new(self, value.color, value.x, value.y)
	  self:addChildAndBody(paddle)
	elseif value.object == "ball" then
	  self.ballColor = value.color
	  self.ballX = value.x
	  self.ballY = value.y
	  self.ballImpulseX = value.impulseX
	  self.ballImpulseY = value.impulseY  
	elseif value.object == "brick" then
      x = value.x
      for j = 1, value.count do
        local brick = Brick.new(self, value.color, x, value.y, value.points)
        self:addChildAndBody(brick)
	    x = x + brick:getWidth() + 6
	    self.bricksLeft = self.bricksLeft + 1
	  end
	end
  end
 
  -- Display the score.
  self.score = SETTINGS:get("currentScore")
  self.scoreText = TextField.new(CONFIG.fontMedium, "Score: "..self.score)
  self.scoreText:setTextColor(0xff0000)
  self.scoreText:setPosition(100, 200)
  self.scoreTextX = self.scoreText:getX()
  self.scoreTextY = self.scoreText:getY()
  self:addChild(self.scoreText) 
  
  -- Register event listeners.
  self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)

  -- Serve the ball.
  Timer.delayedCall(3000, self.createBall, self)
end

function GameScene:createBall()
  if self.ball then
    table.insert(self.bodiesToRemove, self.ball.body)
  end
  self.ball = Ball.new(self, self.ballColor, self.ballX, self.ballY, self.ballImpulseX, self.ballImpulseY)
  self.ball:createBody()
  self:addChildAndBody(self.ball)
end

function GameScene:addChildAndBody(sprite)
  self:addChild(sprite)
  -- Store each physical body in a table with a unique key
  self.bodies[self.bodiesAdded + 1] = sprite.body
  sprite.body.bodyNumber = self.bodiesAdded + 1
  self.bodiesAdded = self.bodiesAdded + 1
end

function GameScene:updateScore(score)
  self.score = self.score + score
  self.scoreText:setText("Score: "..self.score)
end

function GameScene:shakeScore()
  self.scoreText:setX(self.scoreTextX)
  local shake = 50
  GTween.new(self.scoreText, 0.5, {x=self.scoreTextX + shake, y=self.scoreTextY}, {delay=0, ease=easing.outBounce})
end

function GameScene:completed()
  maxLevels = 3
  SOUNDS:play("complete")
  level = SETTINGS:get("currentLevel")
  if level < maxLevels then
    SETTINGS:set("currentLevel", level+1) 
  SETTINGS:set("currentScore", self.score)
  SCENEMANAGER:changeScene("game", CONFIG.transitionTime, CONFIG.transition, CONFIG.easing)
  else
    SETTINGS:set("currentLevel", 1)
    SCENEMANAGER:changeScene("finished", CONFIG.transitionTime, CONFIG.transition, CONFIG.easing)
  end
end

function GameScene:onBeginContact(e)
  local fixtureA = e.fixtureA
  local fixtureB = e.fixtureB
  local bodyA = fixtureA:getBody()
  local bodyB = fixtureB:getBody()
  if bodyA.type and bodyB.type then
    if bodyA.type == "Brick" and bodyB.type == "Ball" then
      SOUNDS:play(bodyA.object.color)
    end
  end
end

function GameScene:onPostSolve(e)
  local fixtureA = e.fixtureA
  local fixtureB = e.fixtureB
  local bodyA = fixtureA:getBody()
  local bodyB = fixtureB:getBody()
  if bodyA.type and bodyB.type then
    if bodyA.type == "Brick" and bodyB.type == "Ball" then
      -- Mark the brick for removal.
      table.insert(self.bodiesToRemove, bodyA.bodyNumber)

      self:updateScore(bodyA.object.points)
      self.bricksLeft = self.bricksLeft - 1
      if self.bricksLeft == 0 then
        self:completed()
      end
    elseif bodyA.type == "Floor" and bodyB.type == "Ball" then
      -- Mark the ball for removal
      self.ballUnderFloor = bodyB

      self:shakeScore()
      self:updateScore(-100)
    end
  end
end

function GameScene:onEnterFrame()
  if not self.paused then
     -- Create a new ball if the last one fell through the floor.
    if self.ballUnderFloor then
      self:removeChild(self.ballUnderFloor.object)
      self.ballUnderFloor:setActive(false)
      self.ballUnderFloor = nil
      Timer.delayedCall(3000, self.createBall, self)
    end
  
    -- Remove any bodies that were marked for removal in the previous frame.
    repeat
      local removed = table.remove(self.bodiesToRemove)
      if removed then
        body = self.bodies[removed]
        if body and body.object then
          body.object:removeFromParent()
          body.object = nill
          body:setActive(false)
        end
      end
    until not removed 

    -- Update the World state
    self.world:step(1/60, 8, 3)
    local body
    for _, body in pairs(self.bodies) do
      if body and body.object then
        -- Update the sprite's position to match the box2d world position
        body.object:setPosition(body:getPosition())
        -- Update the sprite's rotation to match the box2d world rotation 
        body.object:setRotation(math.deg(body:getAngle()))
      end
    end
  end
end
