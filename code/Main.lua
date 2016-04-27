require "box2d"
require "code/Settings"
require "code/Sounds"

-- Define Scenes.
SCENEMANAGER = SceneManager.new({
  ["game"] = GameScene,
  ["finished"] = FinishedScene,
})

SETTINGS = Settings.new()

-- Load sounds based on saved settings.
SOUNDS = Sounds.new()
SOUNDS:addEventListener("soundsOn", function() SETTINGS:set("sound", true, true) end)
SOUNDS:addEventListener("soundsOff", function() SETTINGS:set("sound", false, true) end)
if SETTINGS:get("sounds") then
  SOUNDS:on()
end
SOUNDS:add("complete", "sounds/completed.wav")
SOUNDS:add("green", "sounds/green.wav")
SOUNDS:add("pink", "sounds/pink.wav")
SOUNDS:add("yellow", "sounds/yellow.wav")
SOUNDS:add("blue", "sounds/blue.wav")


-- Load the initial scene.
stage:addChild(SCENEMANAGER)
SCENEMANAGER:changeScene("game", CONFIG.transitionTime, CONFIG.transition, CONFIG.easing)
