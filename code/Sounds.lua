Sounds = Core.class(EventDispatcher)

function Sounds:init()
  self.isOn = false
  self.sounds = {}
  self.eventOn = Event.new("soundsOn")
  self.eventOff = Event.new("soundsOff")
end

function Sounds:on()
  if not self.isOn then
    self.isOn = true
    self:dispatchEvent(self.eventOn)
  end
end

function Sounds:off()
  if self.isOn then
    self.isOn = false
    self:dispatchEvent(self.eventOff)
  end
end

function Sounds:add(name, sound)
  self.sounds[name] = Sound.new(sound)
end

function Sounds:play(name)
  if self.isOn and self.sounds[name] then
    self.sounds[name]:play()
  end
end
