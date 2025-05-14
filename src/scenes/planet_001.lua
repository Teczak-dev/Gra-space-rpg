--[[
    * Planet001
    * This module represents a planet in the game. It handles the loading of the planet's map,
    * the creation of water and building objects, and their rendering.
]]
Pickup = require 'src/systems/Inventory/ItemPickup'
local Planet001 = {}
Planet001.__index = Planet001

function Planet001:new(x, y)
    local planet = {}
    setmetatable(planet, Planet001)
    
    planet.x = x
    planet.y = y
    planet.water = {}
    planet.builds = {} 
    planet.map = sti("assets/tilemaps/planet_001.lua")

    if planet.map.layers["water"] then
        for i, obj in pairs(planet.map.layers["water"].objects) do
            water_junk = {}
            water_junk.body = love.physics.newBody(world, obj.x, obj.y, "static")
            water_junk.shape = love.physics.newRectangleShape(obj.width/2,obj.height/2,  obj.width, obj.height)
            water_junk.fixture = love.physics.newFixture(water_junk.body, water_junk.shape)
            table.insert(planet.water, water_junk)
        end
    end
	
	
	if planet.map.layers["builds"] then
        for i, obj in pairs(planet.map.layers["builds"].objects) do
            build = {}
            build.body = love.physics.newBody(world, obj.x, obj.y, "static")
            build.shape = love.physics.newRectangleShape(obj.width/2,obj.height/2,  obj.width, obj.height)
            build.fixture = love.physics.newFixture(build.body, build.shape)
            table.insert(planet.builds, build)
        end
    end

    planet.items = {
        Pickup:new(itemsDB.getItem("Health pack"), 6916, 4000),
        Pickup:new(itemsDB.getItem("Health pack"), 6916 - 150, 4000),
        Pickup:new(itemsDB.getItem("Health pack"), 6916 - 300, 4000),
        Pickup:new(itemsDB.getItem("Health pack"), 6916 - 450, 4000),
        Pickup:new(itemsDB.getItem("Health pack"), 6916 - 600, 4000),
        Pickup:new(itemsDB.getItem("Health pack"), 6916 - 750, 4000),
    }

    --planet.image = love.graphics.newImage("assets/player.png")
    
    return planet  
end

function Planet001:update(dt)
    if #self.items > 0 then
        for i, item in ipairs(self.items) do
            item:update(dt, i)
            if item.canDelete then
                table.remove(self.items, i)
            end
        end
    end
end

function Planet001:draw()
    love.graphics.setColor(1, 1, 1)
    self.map:drawLayer(self.map.layers["ground"])

    if #self.items > 0 then
        for i, item in ipairs(self.items) do
            item:draw()
        end
    end
end

return Planet001