Paddle = Core.class(Sprite)

function Paddle:init(level, color, x, y)
  self.level = level
  self:setPosition(x,y)

  self.bitmap = Bitmap.new(self.level.tex:getTextureRegion("bat_"..color..".png"))
  self.bitmap:setAnchorPoint(0.5,0.5)
  self:addChild(self.bitmap)  

  self:createBody()
  
  self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
  self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
  self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end

function Paddle:createBody()
  
  -- Physical body of same size and shape
  local body = self.level.world:createBody{type = b2.STATIC_BODY}
  body:setPosition(self:getPosition())
  body:setAngle(math.rad(self:getRotation()))
  
  x, y, w, h = self.bitmap:getBounds(self)
  local box = b2.PolygonShape.new()
  box:setAsBox(w/2, h/2)
  local fixture = body:createFixture{shape = box,
    density = 1.0, friction = 0.1, restitution = 1.4}

  body.type = "Paddle"
  self.body = body
  body.object = self
end

function Paddle:onMouseDown(e)
  if self:hitTestPoint(e.x, e.y) then
    e:stopPropagation()
    self.startX = self:getX()
    self.startY = self:getY()
    self.isDragged = true
  end
end

function Paddle:onMouseMove(e)
  if self.isDragged then
    e:stopPropagation()
    self:setPosition(e.x, self.startY)
    self.body:setPosition(self:getPosition())
    self.body:setAngle(math.rad(self:getRotation()))
  end
end

function Paddle:onMouseUp(e)
  self:setPosition(e.x, e.y)
  if self.isDragged then
    e:stopPropagation()
    self.isDragged = false
  end
end
