Brick = Core.class(Sprite)

function Brick:init(level, color, x, y, points)
  self.level = level
  self.color = color
  self.points = points
  self:setPosition(x,y)

  self.bitmap = Bitmap.new(self.level.tex:getTextureRegion("brick_"..color.."_small.png"))
  self.bitmap:setAnchorPoint(0.5,0.5)
  self:addChild(self.bitmap)
  self:createBody()
end

function Brick:createBody()
  local body = self.level.world:createBody{type = b2.STATIC}
  body:setPosition(self:getPosition())
  body:setAngle(math.rad(self:getRotation()))
  
  local box = b2.PolygonShape.new()
  box:setAsBox(self.bitmap:getWidth()/2, self.bitmap:getHeight()/2)
  local fixture = body:createFixture{shape = box,
    density = 1.0, friction = 0.1, restitution = 1.1}

  body.type = "Brick"
  self.body = body
  body.object = self
end

function Brick:getWidth()
  return self.bitmap:getWidth()
end

