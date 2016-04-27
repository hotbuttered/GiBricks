Ball = Core.class(Sprite)

function Ball:init(level, color, x, y, impulseX, impulseY)
  self.level = level
  self.color = color
  self:setPosition(x,y)
  self.impulseX = impulseX
  self.impulseY = impulseY

  self.bitmap = Bitmap.new(self.level.tex:getTextureRegion("ball_"..color..".png"))
  self.bitmap:setAnchorPoint(0.5,0.5)
  self:addChild(self.bitmap)
end

function Ball:createBody()
  
  -- Physical body of same size and shape
  local radius = self.bitmap:getWidth()/2
  local body = self.level.world:createBody{type = b2.DYNAMIC_BODY}
  body:setPosition(self:getPosition())
  body:setAngle(math.rad(self:getRotation()))
  
  local circle = b2.CircleShape.new(0, 0, radius)
  local fixture = body:createFixture{shape = circle, density = 1.0, 
  friction = 0, restitution = 0.8}
  
  body.type = "Ball"
  self.body = body
  body.object = self
  
  -- Launch the ball.
  self.body:applyLinearImpulse(self.impulseX, self.impulseY, self:getX(), self:getY())  
end
