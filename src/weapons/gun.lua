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
    
    love.graphics.push()
    love.graphics.translate(self.x , self.y)
    love.graphics.rotate(self.angle)
    love.graphics.rectangle("fill", 0, -self.height / 2, self.width, self.height)
    love.graphics.pop()

    for _, b in ipairs(bullets) do
        b:draw()
    end
end
function Gun:update(dt)
    self.x, self.y = player.x + player.width/2 , player.y + player.height/2
    self.lastShotTime = self.lastShotTime - dt

    local mx, my = love.mouse.getPosition()
    local worldX, worldY = cam:worldCoords(mx, my)

    ---@diagnostic disable-next-line: deprecated
    self.angle = math.atan2((worldY - self.y), (worldX - self.x))
    --self.isShot = false

    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet:update(dt)
        if bullet.toRemove then
            table.remove(bullets, i)
        end
    end
    
end
function Gun:shoot()
    gun.isShot = true
    local mx, my = love.mouse.getPosition()
    local worldX, worldY = cam:worldCoords(mx, my)

    ---@diagnostic disable-next-line: deprecated
    local direction = math.atan2((worldY - self.y), (worldX - self.x))
    local bullet = Bullet:new(self.x, self.y, direction)
    table.insert(bullets, bullet) -- Assuming you have a bullets table to store active bullets
    
end

return Gun