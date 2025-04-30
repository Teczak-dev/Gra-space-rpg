-- INITATION variables
-- This is the main file for a simple Love2D game
-- It sets up the window size, title, and fullscreen mode
-- and initializes the game.
SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDesktopDimensions()
--SCREEN_WIDTH, SCREEN_HEIGHT = SCREEN_WIDTH * 0.8, SCREEN_HEIGHT * 0.8
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
Gun = require 'src/weapons/gun'
Bullet = require 'src/logic/bullet'


-- Load systems
Pause = require 'src/systems/pause'
PlayerUI = require 'src/systems/playerUI'

function love.load()
	
	love.window.resizable = true
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.window.setTitle(GAME_TITLE)
    love.window.setFullscreen(IS_FULLSCREEN)
    love.graphics.setDefaultFilter("nearest", "nearest")

    world = love.physics.newWorld(0, 0)
    planet_001 = Planet_001:new(0, 0)
    sm = SceneManager:new(planet_001, {planet_001})
    pause = Pause:new()

    player = Player:new(6322 , 1160)

    playerUI = PlayerUI:new(player)
    gun = Gun:new(player.x, player.y)
	cam = camera(player.x, player.y)
	
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
    cam:lockPosition(player.x + player.width ,player.y + player.height, cam.smooth.damped(5))
	--cam:lookAt(player.x+player.width, player.y+player.height)
    cam_limits()


    mx, my = love.mouse.getPosition()
    worldX, worldY = cam:worldCoords(mx, my)

    gun:update(dt)
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
    love.graphics.print("X: " .. player.x .. " Y: " .. player.y, 10, SCREEN_HEIGHT- 100)
    love.graphics.print("Map! X: " .. planet_001.map.width*planet_001.map.tilewidth .. " Y: " .. planet_001.map.height*planet_001.map.tilewidth, 10, SCREEN_HEIGHT-120)
    love.graphics.print("Mouse! X: " .. mx .. " Y: " .. my, 10, SCREEN_HEIGHT-140)
    love.graphics.print("World! X: " .. worldX .. " Y: " .. worldY, 10, SCREEN_HEIGHT-160) -- cordy w świecie gry
    love.graphics.print("Weapon Rotation" .. gun.angle, 10, SCREEN_HEIGHT-180) -- czy strzela
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
    if button == 1 then
        if pause.isPaused then
            pause:mouse(x,y)
        end
        if gun.lastShotTime <= 0 then
            gun:shoot()
            gun.lastShotTime = gun.cooldown
        end

    end
    
end