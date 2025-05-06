--[[
    * Planet001
    * This module represents a planet in the game. It handles the loading of the planet's map,
    * the creation of water and building objects, and their rendering.
]]
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

    --planet.image = love.graphics.newImage("assets/player.png")
    
    return planet  
end

function Planet001:draw()
    love.graphics.setColor(1, 1, 1)
    self.map:drawLayer(self.map.layers["ground"])
end

return Planet001