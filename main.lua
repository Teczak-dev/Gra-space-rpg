-- INITATION variables
-- This is the main file for a simple Love2D game
-- It sets up the window size, title, and fullscreen mode
-- and initializes the game.

local night_shader = [[
    extern vec2 player_position; // Player's position in screen coordinates
    extern float light_radius;   // Radius of the light around the player

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        // Calculate the distance from the current pixel to the player's position
        float distance = distance(screen_coords, player_position);

        // If the pixel is within the light radius, keep it bright; otherwise, darken it
        if (distance < light_radius) {
            vec4 texel = Texel(texture, texture_coords) * color;
            float alpha = 1.0 - smoothstep(light_radius * 0.8, light_radius, distance);
            return vec4(texel.rgb, texel.a * alpha); // Bright pixel
        } else {
            return vec4(0.0, 0.0, 0.0, 1.0); // Dark pixel
        }
    }
]]

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
NPC = require 'src/characters/test_npc'


-- Load systems
Scenario = require 'src/npc/scenario'
Pause = require 'src/systems/pause'
PlayerUI = require 'src/systems/playerUI'
Save_load = require 'src/systems/saveload'
TalkSys = require 'src/systems/talksys'
Time = require 'src/systems/time'

DEBUG_TEXT = ""
function love.load()
    s = Settings:new()
	love.window.resizable = true
    love.window.setMode(s.SCREEN_WIDTH, s.SCREEN_HEIGHT)
    love.window.setTitle(s.GAME_TITLE)
    love.window.setFullscreen(s.IS_FULLSCREEN)
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    world = love.physics.newWorld(0, 0)

    scenario = Scenario:new("planet_001")
    talk = TalkSys:new()
    planet_001 = Planet_001:new(0, 0)
    sm = SceneManager:new(planet_001, {planet_001})
    pause = Pause:new()
    player = Player:new(6322 , 1160)
    playerUI = PlayerUI:new(player)
    gun = Gun:new(player.x, player.y)
	cam = camera(player.x, player.y)
    save_load = Save_load:new()
    save_load:loadSettings()

    n_shader = love.graphics.newShader(night_shader)
    n_shader:send("light_radius", player.light_radius)
    n_shader:send("player_position", {player.x, player.y})
    time = Time:new()

end

function love.update(dt)
    
    local maxDt = 1 / 60 -- Limit to 60 FPS
    dt = math.min(dt, maxDt)

    local playerX, playerY = cam:cameraCoords(player.x, player.y)
    n_shader:send("player_position", {playerX + player.width, playerY + player.height/2})

    DEBUG_TEXT = ""
    if not pause.isPaused then
        player:update(dt)
        world:update(dt)
        if player.x and player.y then
            cam:lockPosition(player.x + player.width ,player.y + player.height, cam.smooth.damped(5))
        end
        --cam:lookAt(player.x+player.width, player.y+player.height)
        cam_limits()
        mx, my = love.mouse.getPosition()
        worldX, worldY = cam:cameraCoords(mx, my)
        gun:update(dt)
        talk:update(dt)
        time:update(dt)
        
    end
    pause:update(dt)
end
function love.draw()
    if not time.isDay then
        love.graphics.setShader(n_shader)
    end
    cam:attach()
        sm.currentScene:draw()
        --drawColliders()
        for i, npc in ipairs(Npcs) do
            --print(i .. " " .. npc.x .. " " .. npc.y)
            npc:draw()
        end
        --time:draw()
        player:draw()
        gun:draw()
    cam:detach()

    love.graphics.setShader()

    playerUI:draw()
    debug()
    pause:draw()
    talk:draw()
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
    love.graphics.print("Volume: " .. love.audio.getVolume(), 10, s.SCREEN_HEIGHT-220) -- 
    love.graphics.print("Time: " .. time.time, 10, s.SCREEN_HEIGHT-240) --
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
    if key == "escape" and pause.canPause then
        if pause.isPaused then
            if pause.isOptions then
                pause:Options()
                save_load:saveGame()
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
    if key == "space" then
        if talk.isTalking then
            talk.talk_time = talk.dialogues[1].time
        end
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