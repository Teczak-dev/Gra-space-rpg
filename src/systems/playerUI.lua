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
    playerUI.hpBar = {
        x = 10,
        y = 10,
        width = 200,
        height = 20
    }

    playerUI.dashBar = {
        x = s.SCREEN_WIDTH/2 - 250,
        y = s.SCREEN_HEIGHT- 100,
        width = 500,
        height = 20
    }

    playerUI.is = {
        mapOpen = false
    }

    playerUI.map_img = love.graphics.newImage("assets/map_img/test.JPG")


    return playerUI
end

function PlayerUI:draw()
    -- Draw the health bar
    local hpPercentage = self.player.hp / self.player.maxhp
    love.graphics.setColor(1, 0, 0) -- Red color for the health bar
    love.graphics.rectangle("fill", self.hpBar['x'], self.hpBar['y'], self.hpBar['width'] * hpPercentage, self.hpBar['height'])

    -- draw dash cooldown bar
    love.graphics.setColor(0, 0, 1) -- Blue color for the dash cooldown bar
    local dashPercentage = self.player.dash_time / self.player.dash_cooldown
    if dashPercentage > 1 then
        dashPercentage = 1
    end
    if dashPercentage ~= 1 then
        love.graphics.rectangle("fill", self.dashBar['x'], self.dashBar['y'], self.dashBar['width'] * dashPercentage, self.dashBar['height'])
        love.graphics.setColor(1, 1, 1) -- Reset color to white
    end
    if self.is.mapOpen then
        love.graphics.setColor(1, 1, 1) -- Reset color to white
        love.graphics.draw(self.map_img, 200, 50, 0, love.graphics.getWidth() / self.map_img:getWidth() * 0.7 )
    end
end
function PlayerUI:update(dt)
    -- Update the player UI if needed
    
end

function PlayerUI:OpenCloseMap()
    self.is.mapOpen = not self.is.mapOpen
end

function PlayerUI:UpdateAfterChangeOfResolution()
    self.dashBar.x = s.SCREEN_WIDTH/2 - 250
    self.dashBar.y = s.SCREEN_HEIGHT- self.dashBar.height - 10
    
end


return PlayerUI