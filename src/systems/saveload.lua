local SaveLoad = {}
SaveLoad.__index = SaveLoad

function SaveLoad:new()
    local saveLoad = {}
    setmetatable(saveLoad, SaveLoad)
    saveLoad.saveData = {}
    return saveLoad
end

function SaveLoad:saveSettings(player, world)
    local saveSettins = {}
    saveSettins.IS_FULLSCREEN = s.IS_FULLSCREEN
    saveSettins.current_resolution = s.current_resolution
    saveSettins.volume = love.audio.getVolume()
    
    serializedData = lume.serialize(saveSettins)
    love.filesystem.write("settings.txt", serializedData)

end

function SaveLoad:loadSettings()
    file = love.filesystem.read("settings.txt")
    if not file then
        return
    end
    settingsData = lume.deserialize(file)
    if  settingsData then
        s.IS_FULLSCREEN = settingsData.IS_FULLSCREEN or s.IS_FULLSCREEN
        s.current_resolution = settingsData.current_resolution or s.current_resolution
        love.audio.setVolume(settingsData.volume)
        s:toggleWindow()
    end
end

return SaveLoad