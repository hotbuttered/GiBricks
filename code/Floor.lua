Floor = Core.class(Sprite)

function Floor:init(level)
  local body = level.world:createBody{type = b2.STATIC_BODY}
  body:setPosition(0,0)
  
  local chain = b2.ChainShape.new()
  chain:createChain(
    0, CONFIG.height,
    CONFIG.width, CONFIG.height,
    CONFIG.width, CONFIG.height,
    0, CONFIG.height,
    0, CONFIG.height
    )

  local fixture = body:createFixture{shape = chain,
    density = 1.0, friction = 1.0, restitution = 0.5}

  body.type = "Floor"
end
