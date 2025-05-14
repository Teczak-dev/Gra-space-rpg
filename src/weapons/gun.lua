--[[
    * Gun class
    * This class represents a gun that can shoot bullets in the direction of the mouse cursor.
    * The gun is drawn as a rectangle and can be rotated to face the mouse cursor.
]]

local Gun = {}
Gun.__index = Gun

bullets = {}

function Gun:new(x, y)
    local gun = {}
    setmetatable(gun, Gun)
    gun.x = x
    gun.y = y
    gun.angle = 0
    gun.width = 30
    gun.height = 10
    gun.cooldown = 0.5 -- Cooldown time in seconds
    gun.lastShotTime = 0
    gun.isShot = false
    return gun
end
function Gun:draw()
    love.graphics.setColor(0, 1, 0) -- Set gun color to green
    
    -- Broń jest teraz rysowana w funkcji draw gracza, więc tutaj możemy usunąć 
    -- kod rysowania broni albo pozostawić go pusty
    
    -- Rysujemy tylko pociski
    for _, b in ipairs(bullets) do
        b:draw()
    end
end

function Gun:update(dt)
    -- Aktualizuj położenie broni na podstawie pozycji i obrotu gracza
    self.x = player.x
    self.y = player.y
    self.angle = player.angle
    
    -- Odliczaj czas do kolejnego strzału
    self.lastShotTime = self.lastShotTime - dt
    
    -- Aktualizuj pociski
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet:update(dt)
        if bullet.time_to_remove <= 0 then
            table.remove(bullets, i)
            removeBody(bullet.body)
        end
    end
end

function Gun:shoot()
    -- Używamy kąta obrotu gracza zamiast obliczać go względem myszy
    local angle = player.angle
    
    -- Obliczamy pozycję końca broni uwzględniając obrót
    local offsetX = self.width + 20 + 5 -- Długość broni + przesunięcie
    local offsetY = 22 -- Zakładamy, że broń jest na środku postaci
    
    -- Obliczamy pozycję końca broni w przestrzeni świata
    local bulletX = player.x + math.cos(angle) * offsetX - math.sin(angle) * offsetY
    local bulletY = player.y + math.sin(angle) * offsetX + math.cos(angle) * offsetY
    
    -- Tworzymy nowy pocisk na końcu broni, z kierunkiem odpowiadającym kątowi obrotu gracza
    table.insert(bullets, Bullet:new(bulletX, bulletY, angle))
    
    -- Resetujemy czas do kolejnego strzału
    self.lastShotTime = self.cooldown
    self.isShot = true
end

return Gun