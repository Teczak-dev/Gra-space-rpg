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
    self.canMove = true
    self.sprite = love.graphics.newImage("assets/sprites/character.png") 
    self.x = x
    self.y = y
    self.width = 64-16
    self.height = 64
    self.normal_speed = 20000
    self.speed = 20000
    self.sprint_speed = 40000
    self.dash = 100
    self.dash_cooldown = 0.5
    self.dash_time = 0
    self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width* 1.3, self.height/2+7,self.width, self.height)
    player.fixture = love.physics.newFixture(self.body, self.shape)
    player.body:setFixedRotation(true)


    self.hp = 100
    self.maxhp = 100
    --player.image = love.graphics.newImage("assets/player.png")
    
    return player  
end

function Player:draw()
	love.graphics.draw(self.sprite, self.x, self.y, 0, 2,2)
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
                --DEBUG_TEXT = "space"
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