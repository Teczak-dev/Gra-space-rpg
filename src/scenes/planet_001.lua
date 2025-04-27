local Planet001 = {}
Planet001.__index = Planet001

function Planet001:new(x, y)
    local planet = {}
    setmetatable(planet, Planet001)
    planet.x = x
    planet.y = y
    planet.width = 32
    planet.height = 32
    planet.speed = 300
    planet.collider = world:newBSGRectangleCollider(x, y, planet.width, planet.height, 10)
    planet.collider:setFixedRotation(true)
    --planet.image = love.graphics.newImage("assets/player.png")
    
    return planet  
    
end