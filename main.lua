-- INITATION variables
-- This is the main file for a simple Love2D game
-- It sets up the window size, title, and fullscreen mode
-- and initializes the game.

-- Load libraries

camera = require 'libraries/camera'
anim8 = require 'libraries/anim8'
sti = require 'libraries/sti'
lume = require 'libraries/lume'
-- Load settings
Settings = require 'src/systems/settings'
s = Settings:new()


-- Load maps
SceneManager = require 'src/scenes/sceneManager'
Planet_001 = require 'src/scenes/planet_001'

-- Load character
Player = require 'src/characters/player'
Gun = require 'src/weapons/gun'
Bullet = require 'src/logic/bullet'


-- Load systems
Pause = require 'src/systems/pause'
PlayerUI = require 'src/systems/playerUI'
Save_load = require 'src/systems/saveload'

DEBUG_TEXT = ""
function love.load()
    s = Settings:new()
    

    
	love.window.resizable = true
    love.window.setMode(s.SCREEN_WIDTH, s.SCREEN_HEIGHT)
    love.window.setTitle(s.GAME_TITLE)
    love.window.setFullscreen(s.IS_FULLSCREEN)
    love.graphics.setDefaultFilter("nearest", "nearest")


    world = love.physics.newWorld(0, 0)
    planet_001 = Planet_001:new(0, 0)
    sm = SceneManager:new(planet_001, {planet_001})
    pause = Pause:new()

    player = Player:new(6322 , 1160)

    playerUI = PlayerUI:new(player)
    gun = Gun:new(player.x, player.y)
	cam = camera(player.x, player.y)
	

    save_load = Save_load:new()
    save_load:loadGame()
end


function love.update(dt)
    DEBUG_TEXT = ""
    player:update(dt)
    world:update(dt)
    cam:lockPosition(player.x + player.width ,player.y + player.height, cam.smooth.damped(5))
	--cam:lookAt(player.x+player.width, player.y+player.height)
    cam_limits()
    mx, my = love.mouse.getPosition()
    worldX, worldY = cam:worldCoords(mx, my)
    pause:update(dt)
    gun:update(dt)
end
function love.draw()

    cam:attach()
        sm.currentScene:draw()
        --wdrawColliders()
        player:draw()
        gun:draw()
    cam:detach()
    playerUI:draw()
    debug()
    pause:draw()
end

-- this function limits the camera positions to the map
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

-- show important information on the screen
function debug()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(22))
    love.graphics.print("X: " .. player.x .. " Y: " .. player.y, 10, s.SCREEN_HEIGHT- 100)
    love.graphics.print("Map! X: " .. planet_001.map.width*planet_001.map.tilewidth .. " Y: " .. planet_001.map.height*planet_001.map.tilewidth, 10, s.SCREEN_HEIGHT-120)
    love.graphics.print("Mouse! X: " .. mx .. " Y: " .. my, 10, s.SCREEN_HEIGHT-140)
    love.graphics.print("World! X: " .. worldX .. " Y: " .. worldY, 10, s.SCREEN_HEIGHT-160) -- cordy w świecie gry
    love.graphics.print("Weapon Rotation" .. gun.angle, 10, s.SCREEN_HEIGHT-180) -- czy strzela
    love.graphics.print("DEBUG: " .. DEBUG_TEXT, 10, s.SCREEN_HEIGHT-200) -- 
    love.graphics.print("Volume: " .. love.audio.getVolume(), 10, s.SCREEN_HEIGHT-220) -- FPS
end

-- Draw colliders for debugging purposes
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


-- Inputs

function love.keypressed(key)
    if key == "escape" then
        if pause.isPaused then
            if pause.isOptions then
                pause:Options()
            else
                pause:resume()
            end
            
        else
            pause:pause()
        end
    end
    if key == "m" then
        playerUI:OpenCloseMap()
    end
end

function love.mousepressed(x,y, button)
    if button == 1 then
        if pause.isPaused then
            pause:mouse(x,y)
        else
            if gun.lastShotTime <= 0 then
                gun:shoot()
                gun.lastShotTime = gun.cooldown
            end
        end
    end
end
function love.mousereleased(x,y, button)
    if button == 1 then
        if pause.isOptions then
            pause:SetDragging()
        end
    end
    
end