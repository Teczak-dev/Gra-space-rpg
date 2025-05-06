--[[
    * Bullet class for the game
    * This class handles the
    * creation, drawing, and updating of bullets.
    ]]

local Bullet = {}
Bullet.__index = Bullet

function Bullet:new(x, y, direction)
    local bullet = {}
    setmetatable(bullet, Bullet)
    bullet.x = x
    bullet.y = y
    bullet.width = 10
    bullet.height = 10
    bullet.speed = 1000
    bullet.time_to_remove = 2
    bullet.direction = direction
    bullet.body = love.physics.newBody(world, x, y, "dynamic")
    bullet.shape = love.physics.newRectangleShape(bullet.width, bullet.height)
    bullet.fixture = love.physics.newFixture(bullet.body, bullet.shape)
    bullet.fixture:setSensor(true) -- Set the fixture as a sensor to avoid collisions with other objects
    return bullet
end
function Bullet:draw()
    love.graphics.setColor(1, 0, 0) -- Set bullet color to red
    love.graphics.circle("fill", self.x, self.y, self.width)
end
function Bullet:update(dt)
    self.time_to_remove = self.time_to_remove - dt
    local vx = self.speed * math.cos(self.direction)
    local vy = self.speed * math.sin(self.direction)
    self.body:setLinearVelocity(vx, vy)

    -- Update position
    self.x, self.y = self.body:getPosition()

end
function Bullet:destroy()
    if self.body then
        self.body:destroy()
        self.body = nil
    end
end

return Bullet