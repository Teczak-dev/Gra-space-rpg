--[[
    * SceneManager class
    * This class is responsible for managing the current scene in the game.
    * It allows switching between different scenes and loading new ones.
]]
local SceneManager = {}
SceneManager.__index = SceneManager


function SceneManager:new(startScene, scenes)
    local sceneManager = {}
    setmetatable(sceneManager, SceneManager)
    sceneManager.currentScene = startScene
    return sceneManager
    
end

function SceneManager:loadScene(scene)
    if scene == nil then
        return
    end
    if self.currentScene == scene then
        return
    end
    self.currentScene = scene
end

return SceneManager