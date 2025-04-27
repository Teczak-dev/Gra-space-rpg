local Player = {}
Player.__index = Player

local isLoad = false

function Player:new(x,y)
    local player = {}
    setmetatable(player, Player)
    self.x = x
    self.y = y
    self.width = 32
    self.height = 32
    self.speed = 300
    self.collider = world:newBSGRectangleCollider(x, y, player.width, player.height, 10)
    self.collider:setFixedRotation(true)
    --player.image = love.graphics.newImage("assets/player.png")
    
    return player  
end

function Player:draw()
    love.graphics.setColor(1, 0.2, 0.7)
    love.graphics.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)
end

function Player:update(dt)
    isLoad = true
    local speed = self.speed
    local vx = 0
    local vy = 0

    if love.keyboard.isDown("w") or love.keyboard.isDown("up")  then
        vy = -speed
    end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        vy = speed
    end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        vx = -speed
    end
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        vx = speed
    end

    self.collider:setLinearVelocity(vx, vy)
    
    isLoad = false
end

return Player