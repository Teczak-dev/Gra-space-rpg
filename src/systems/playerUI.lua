--[[
    * PlayerUI.lua
    * This module handles the player UI, specifically the health bar.
]]

local PlayerUI = {}
PlayerUI.__index = PlayerUI

function PlayerUI:new(player)
    local playerUI = {}
    setmetatable(playerUI, PlayerUI)

    playerUI.player = player
    playerUI.hpBarWidth = 200
    playerUI.hpBarHeight = 20
    playerUI.hpBarX = 10
    playerUI.hpBarY = 10


    return playerUI
end

function PlayerUI:draw()
    -- Draw the health bar
    local hpPercentage = self.player.hp / self.player.maxhp
    love.graphics.setColor(1, 0, 0) -- Red color for the health bar
    love.graphics.rectangle("fill", self.hpBarX, self.hpBarY, self.hpBarWidth * hpPercentage, self.hpBarHeight)
    love.graphics.setColor(1, 1, 1) -- Reset color to white
end
function PlayerUI:update(dt)
    -- Update the player UI if needed
end
function PlayerUI:destroy()
    -- Clean up if needed
end
function PlayerUI:reset()
    -- Reset the player UI if needed
end

return PlayerUI