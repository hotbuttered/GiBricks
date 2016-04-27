require "code/utils/scenemanager"
require "code/utils/easing"

CONFIG = {
  debugDraw = false,
  transition = SceneManager.fade,
  transitionTime = 1,
  easing = easing.outBack,
  width = application:getContentWidth(),
  height = application:getContentHeight(),
  dx = application:getLogicalTranslateX() / application:getLogicalScaleX(),
  dy = application:getLogicalTranslateY() / application:getLogicalScaleY(),
  fontLarge = TTFont.new("fonts/blowbrush.otf", 150, true),
  fontMedium = TTFont.new("fonts/blowbrush.otf", 120, true),
  fontSmall = TTFont.new("fonts/blowbrush.otf", 90, true),
  }
