-- INITATION variables
-- This is the main file for a simple Love2D game
-- It sets up the window size, title, and fullscreen mode
-- and initializes the game.
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
GAME_TITLE = "Space King"
IS_FULLSCREEN = false

-- Load libraries

camera = require 'libraries/camera'
anim8 = require 'libraries/anim8'
sti = require 'libraries/sti'


-- Load maps
SceneManager = require 'src/scenes/sceneManager'
Planet_001 = require 'src/scenes/planet_001'

-- Load character
Player = require 'src/characters/player'


-- Load systems
Pause = require 'src/systems/pause'

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.window.setTitle(GAME_TITLE)
    love.window.setFullscreen(IS_FULLSCREEN)
    love.graphics.setDefaultFilter("nearest", "nearest")

    world = love.physics.newWorld(0, 0)
    cam = camera()
    planet_001 = Planet_001:new(0, 0)
    sm = SceneManager:new(planet_001, {planet_001})
    pause = Pause:new()

    player = Player:new(600, 300)
end

function cam_limits()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    if cam.x < w/2 then
        cam.x = w/2
    end
    -- top border for camera
    if cam.y < h/2 then
        cam.y = h/2
    end

    local mapWidth = sm.currentScene.map.width * sm.currentScene.map.tilewidth
    local mapHeight = sm.currentScene.map.height * sm.currentScene.map.tileheight

    -- right border for camera
    if cam.x > mapWidth - w/2 then
        cam.x = mapWidth - w/2
    end
    -- bottom border for camera
    if cam.y > mapHeight - h/2 then
        cam.y = mapHeight - h/2
    end
end


function love.update(dt)
    player:update(dt)
    world:update(dt)
    cam:lookAt(player.x, player.y)
    cam_limits()

end


function drawColliders()
    for _, body in pairs(world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
    
            if shape:typeOf("CircleShape") then
                local cx, cy = body:getWorldPoints(shape:getPoint())
                love.graphics.circle("fill", cx, cy, shape:getRadius())
            elseif shape:typeOf("PolygonShape") then
                love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
            else
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            end
        end
    end
end


function debug()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(22))
    love.graphics.print("X: " .. player.x .. " Y: " .. player.y, 10, 10)
    love.graphics.print("Map! X: " .. planet_001.map.width*planet_001.map.tilewidth .. " Y: " .. planet_001.map.height*planet_001.map.tilewidth, 10, 30)
end

function love.draw()

    cam:attach()
        planet_001:draw()
        --drawColliders()
        player:draw()
    cam:detach()
    debug()
    pause:draw()
end

function love.keypressed(key)
    if key == "escape" then
        if pause.isPaused then
            pause:resume()
        else
            pause:pause()
        end
    end
end

function love.mousepressed(x,y, button)
    if button == 1 and pause.isPaused then
        pause:mouse(x,y)
    end
    
end