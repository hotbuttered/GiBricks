Button = Core.class(Sprite)

function Button:init(sprite)
  self.sprite = sprite
  self:addChild(sprite)
  self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end

function Button:onMouseUp(event)
  if self:hitTestPoint(event.x, event.y) then
    event:stopPropagation()
    local clickEvent = Event.new("click")
    self:dispatchEvent(clickEvent)
  end
end
