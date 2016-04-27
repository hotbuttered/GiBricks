FinishedScene = Core.class(Sprite)

function FinishedScene:init()
  self.bodies = {}
  self.bodiesToRemove = {}
  self.bodiesAdded = 0
  self.ballUnderFloor = nil

  -- Load the background image.
  local bg = Bitmap.new(Texture.new("images/background.jpg", true))
  bg:setAnchorPoint(0.5, 0.5)
  bg:setPosition(CONFIG.width/2, CONFIG.height/2)
  self:addChild(bg)

  -- Display the message.
  local text = TextField.new(CONFIG.fontLarge, "YOU WON!!")
  text:setTextColor(0xff0000)
  text:setPosition(400, 400)
  self:addChild(text) 

  -- Display the score.
  local score = SETTINGS:get("currentScore")
  local scoreText = TextField.new(CONFIG.fontMedium, "Score: "..score)
  scoreText:setTextColor(0xff0000)
  scoreText:setPosition(400, 800)
  self:addChild(scoreText) 
 
  -- Create the restart button.
  local restartText = TextField.new(CONFIG.fontMedium, "Restart")
  restartText:setTextColor(0xffff00)
  local restartButton = Button.new(restartText)
  restartButton:setPosition(400, 1000)
  self:addChild(restartButton)
  restartButton:addEventListener("click",
    function()
      SCENEMANAGER:changeScene("game", CONFIG.transitionTime, CONFIG.transition, CONFIG.easing)
    end)   
end