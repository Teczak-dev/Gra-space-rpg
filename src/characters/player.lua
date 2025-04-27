local Player = {}
Player.__index = Player


function Player:new(x,y)
    local player = {}
    setmetatable(player, Player)
    self.canMove = true
    self.x = x
    self.y = y
    self.width = 32
    self.height = 32
    self.speed = 20000
    self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width/2,self.height/2,self.width, self.height)
    player.fixture = love.physics.newFixture(self.body, self.shape)
    player.body:setFixedRotation(true)
    --player.image = love.graphics.newImage("assets/player.png")
    
    return player  
end

function Player:draw()
    love.graphics.setColor(1, 0.2, 0.7)
    love.graphics.rectangle("fill", self.x , self.y, self.width, self.height)
end

function Player:update(dt)
    local speed = self.speed * dt
    local vx = 0
    local vy = 0
    if self.canMove then
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
    end

    self.body:setLinearVelocity(vx, vy)

    if self.body:getX() <= 1 or self.body:getX() >= sm.currentScene.map.width * sm.currentScene.map.tilewidth - self.width then
        self.body:setX(self.x)
    end
    if self.body:getY() <= 1 or self.body:getY() >= sm.currentScene.map.width * sm.currentScene.map.tilewidth - self.height then
        self.body:setY(self.y)
    end

    self.x, self.y = self.body:getPosition()

    

end

return Player