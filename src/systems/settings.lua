local Settings = {}
Settings.__index = Settings

function Settings:new()
    local settings = {}
    setmetatable(settings, Settings)

    --* Game Window Settings
    settings.GAME_TITLE = "Space Lord"
    settings.IS_FULLSCREEN = false
    local all_resolutions = love.window.getFullscreenModes()
    settings.resolutions = {}

    for i, mode in ipairs(all_resolutions) do
        if mode.width >= 1280 and mode.height >= 720 then
            table.insert(settings.resolutions, mode)
        end
    end
    table.sort(settings.resolutions, function(a, b) return a.width * a.height > b.width * b.height end)
    settings.current_resolution = #settings.resolutions
    settings.SCREEN_WIDTH, settings.SCREEN_HEIGHT = settings.resolutions[settings.current_resolution].width, settings.resolutions[settings.current_resolution].height
    
    love.window.setMode(
        settings.resolutions[settings.current_resolution].width,
        settings.resolutions[settings.current_resolution].height,
        {
            fullscreen = settings.IS_FULLSCREEN,
            fullscreentype = "exclusive",
            vsync = true,
            resizable = false
        }
    )

    
    return settings
end

function Settings:toggleWindow()
    local mode = self.resolutions[self.current_resolution]
    love.window.setMode(mode.width, mode.height, {
        fullscreen = self.IS_FULLSCREEN,
        fullscreentype = "exclusive",
        vsync = true,
        resizable = false
    })
    self.SCREEN_WIDTH = mode.width
    self.SCREEN_HEIGHT = mode.height
    pause:recreatingObjects()
    playerUI:UpdateAfterChangeOfResolution()
    save_load:saveSettings()
end

function Settings:toggleFullscreen()
    self.IS_FULLSCREEN = not self.IS_FULLSCREEN
    self:toggleWindow()
end

return Settings