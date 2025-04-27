-- INITATION variables
-- This is the main file for a simple Love2D game
-- It sets up the window size, title, and fullscreen mode
-- and initializes the game.
SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
GAME_TITLE = "Space King"
IS_FULLSCREEN = false

-- load libraries
wf = require 'libraries/windfield'
camera = require 'libraries/camera'
anim8 = require 'libraries/anim8'
sti = require 'libraries/sti'


-- Load src files
Player = require 'src/characters/player'

function love.load()
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
    love.window.setTitle(GAME_TITLE)
    love.window.setFullscreen(IS_FULLSCREEN)
    love.graphics.setDefaultFilter("nearest", "nearest")

    world = wf.newWorld(0,0)
    cam = camera()
    
    player = Player:new(100, 100)
    --gameMap = sti("maps/testMap.lua")
end


function love.update(dt)
    player:update(dt)
    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
    cam:lookAt(player.x, player.y)

end

function love.draw()

    cam:attach()
        player:draw()
        world:draw()
    cam:detach()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(22))
    love.graphics.print("X: " .. player.x .. " Y: " .. player.y, 10, 10)
end