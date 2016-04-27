require "code/utils/dataSaver"

Settings = Core.class()

function Settings:init()
local settings = {
  currentLevel = 1,
  currentScore = 0,
  sounds = true,
}

self.isChanged = false
-- Load Saved Settings.
self.sets = dataSaver.load("|D|settings")
if(not self.sets) then
  self.sets = {}
end

-- Copy initial settings
for key, val in pairs(settings) do
  if self.sets[key] == nil then
    self.sets[key] = val
    self.isChanged = true
  end
end
end

function Settings:save()
  if(self.isChanged) then  
    dataSaver.save("|D|settings", self.sets)
  self.isChanged = false
  end
 end
 
 function Settings:get(key)
   return self.sets[key]
 end
 

function Settings:set(key, value, autosave)
  if(self.sets[key] == nil or self.sets[key] ~= value) then
    self.sets[key] = value
    self.isChanged = true
  end
  if autosave then
    self:save()
  end
end
