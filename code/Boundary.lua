Boundary = Core.class(Sprite)

function Boundary:init(level)
  local body = level.world:createBody{type = b2.STATIC_BODY}
  body:setPosition(0,0)
  
  local chain = b2.ChainShape.new()
  chain:createChain(
    0, CONFIG.height,
    0, 0,
    CONFIG.width, 0,
    CONFIG.width, CONFIG.height
    )
  local fixture = body:createFixture{shape = chain,
    density = 1.0, friction = 1.0, restitution = 0.5}

  body.type = "Boundary"
end
