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
    player.too_much_weight_normal_speed = 10000
    player.too_much_weight_sprint_speed = 20000
    player.normal_speed = 20000
    player.speed = 20000
    player.sprint_speed = 40000
    player.dash_duration = 0.15 -- czas trwania dash w sekundach
    player.dash_cooldown = 0.5
    player.dash_time = 0
    player.is_dashing = false
    player.dash_timer = 0
    player.dash_direction_x = 0
    player.dash_direction_y = 0
    player.body = love.physics.newBody(world, player.x, player.y, "dynamic")
    local radius = math.max(player.width, player.height) / 2 * 0.8 -- promień nieco mniejszy niż gracz
    player.shape = love.physics.newCircleShape(radius)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.body:setFixedRotation(true) -- nadal możemy to ustawić, bo okrąg nie wymaga obrotu
    player.hp = 100
    player.maxhp = 100
    player.light_radius = 200
    player.angle = 0
    return player  
end

function Player:draw()
    -- Zapisujemy aktualną transformację
    love.graphics.push()
    
    -- Przesuwamy punkt odniesienia do pozycji gracza
    love.graphics.translate(self.x, self.y)
    
    -- Obracamy wszystko zgodnie z kątem gracza
    love.graphics.rotate(self.angle)
    
    -- Rysowanie postaci gracza
    love.graphics.setColor(0.941, 0.812, 0.369)
    love.graphics.rectangle("fill", -self.width/2, -self.height/2, self.width, self.height)
    
    -- Rysowanie broni po prawej stronie gracza
    love.graphics.setColor(0, 1, 0) -- Kolor broni (zielony)
    
    -- Przesunięcie broni na prawą stronę gracza
    local gunWidth = 30
    local gunHeight = 10
    local gunOffsetX = 5  -- Przesunięcie poziome (0 = dokładnie na prawej krawędzi)
    local gunOffsetY = 22 -- Przesunięcie pionowe w dół od środka gracza
    
    -- Rysujemy broń jako prostokąt na prawej stronie gracza
    love.graphics.rectangle("fill", 
                            self.width/2 + gunOffsetX,  -- Pozycja X (prawa strona gracza)
                            gunOffsetY - gunHeight/2,   -- Pozycja Y (przesunięcie w dół)
                            gunWidth, 
                            gunHeight)
    
    -- Przywracamy poprzednią transformację
    love.graphics.pop()
    
    -- Przywracamy domyślny kolor
    love.graphics.setColor(1, 1, 1, 1)
end

function Player:update(dt)
    self.dash_time = self.dash_time + dt

    -- Aktualizacja dash timer
    if self.is_dashing then
        self.dash_timer = self.dash_timer + dt
        if self.dash_timer >= self.dash_duration then
            self.is_dashing = false
            self.dash_timer = 0
        end
    end

    -- Ustawienie prędkości bazowej
    if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
        if inventory:IsOverWeight() then
            self.speed = self.too_much_weight_sprint_speed
        else
            self.speed = self.sprint_speed
        end
    else
        if inventory:IsOverWeight() then
            self.speed = self.too_much_weight_normal_speed
        else
            self.speed = self.normal_speed
        end
    end
    
    local speed = self.speed * dt
    local vx = 0
    local vy = 0
    
    if self.is_dashing then
        -- Podczas dash, użyj zapisanego kierunku z dużo większą prędkością
        local dash_speed_multiplier = 6.0 -- mnożnik prędkości dash
        local base_speed = self.speed * dt
        vx = self.dash_direction_x * base_speed * dash_speed_multiplier
        vy = self.dash_direction_y * base_speed * dash_speed_multiplier
    elseif self.canMove then
        -- Normalny ruch
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
        
        -- Inicjowanie dash
        if love.keyboard.isDown("space") then
            if self.dash_time >= self.dash_cooldown and not self.is_dashing then
                -- Sprawdź czy gracz się porusza
                if vx ~= 0 or vy ~= 0 then
                    -- Normalizuj kierunek dash
                    local length = math.sqrt(vx * vx + vy * vy)
                    self.dash_direction_x = vx / length
                    self.dash_direction_y = vy / length
                    
                    self.is_dashing = true
                    self.dash_time = 0
                    self.dash_timer = 0
                end
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

    local mx, my = love.mouse.getPosition()
    local worldX, worldY = cam:worldCoords(mx, my)

    ---@diagnostic disable-next-line: deprecated
    self.angle = math.atan2((worldY - self.y), (worldX - self.x))
end

function Player:TakeDamage(damage)
    self.hp = self.hp - damage
    if self.hp <= 0 then
        self.hp = 0
        -- Handle player death (e.g., respawn, game over, etc.)
        print("Player is dead!")
        
    end    
end

return Player