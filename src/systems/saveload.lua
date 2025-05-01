local SaveLoad = {}
SaveLoad.__index = SaveLoad

function SaveLoad:new()
    local saveLoad = {}
    setmetatable(saveLoad, SaveLoad)
    saveLoad.saveData = {}
    return saveLoad
end

function SaveLoad:saveGame(player, world)
    local saveSettins = {}
    saveSettins.IS_FULLSCREEN = s.IS_FULLSCREEN
    saveSettins.current_resolution = s.current_resolution
    
    serializedData = lume.serialize(saveSettins)
    love.filesystem.write("settings.txt", serializedData)

end

function SaveLoad:loadGame()
    file = love.filesystem.read("settings.txt")
    if not file then
        return
    end
    settingsData = lume.deserialize(file)
    if  settingsData then
        s.IS_FULLSCREEN = settingsData.IS_FULLSCREEN
        s.current_resolution = settingsData.current_resolution
        s:toggleWindow()
    end


end

return SaveLoad