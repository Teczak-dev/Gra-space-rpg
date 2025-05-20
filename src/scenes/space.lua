local Space = {}
Space.__index = Space

function Space:new()
    local space = {}
    setmetatable(space, Space)
    
    space.x = 0
    space.y = 0
    space.map = {
        width = 2000,
        height = 2000,
        tilewidth = 64,
        tileheight = 64,
    }

    return space
end

function Space:draw()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", 0, 0, self.map.width, self.map.height)
    for i = 1, 500 do
        local x = math.random(0, self.map.width)
        local y = math.random(0, self.map.height)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.circle("fill", x, y, 2)
    end
end

return Space