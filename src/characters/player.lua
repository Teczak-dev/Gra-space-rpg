--[[
    * Player Class
    * This class represents the player character in the game.
    * It handles player movement, health, and rendering.
]]

local Player = {}
Player.__index = Player


function Player:new(x,y)
    local player = {}
    setmetatable(player, Player)
    player.canMove = true
    player.sprite = love.graphics.newImage("assets/sprites/character.png") 
    player.x = x
    player.y = y
    player.width = 48
    player.height = 64
    player.normal_speed = 20000
    player.speed = 20000
    player.sprint_speed = 40000
    player.dash = 150
    player.dash_cooldown = 0.5
    player.dash_time = 0
    player.body = love.physics.newBody(world, player.x, player.y, "dynamic")
    player.shape = love.physics.newRectangleShape(player.width* 1.3, player.height/2+7,player.width, player.height)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.body:setFixedRotation(true)
    player.hp = 100
    player.maxhp = 100
    player.light_radius = 200
    return player  
end

function Player:draw()
    love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.sprite, self.x, self.y, 0, 2, 2)
end

function Player:update(dt)
    self.dash_time = self.dash_time + dt
    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        self.speed = self.sprint_speed
    else
        self.speed = self.normal_speed
    end
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
        if love.keyboard.isDown("space") then
            
            if self.dash_time >= self.dash_cooldown  then
                vx,vy = vx * self.dash, vy * self.dash
                self.dash_time = 0
            end
        end
    end

    self.body:setLinearVelocity(vx, vy)

    if self.body:getX() <= 1 or self.body:getX() >= sm.currentScene.map.width * sm.currentScene.map.tilewidth - self.width then
        self.body:setX(self.x)
    end
    if self.body:getY() <= 1 or self.body:getY() >= sm.currentScene.map.height * sm.currentScene.map.tilewidth - self.height*2 then
        self.body:setY(self.y)
    end

    self.x, self.y = self.body:getPosition()
end

function Player:TakeDamage(damage)
    self.hp = self.hp - damage
    if self.hp <= 0 then
        -- Handle player death (e.g., respawn, game over, etc.)
        print("Player is dead!")
    end    
end

return Player