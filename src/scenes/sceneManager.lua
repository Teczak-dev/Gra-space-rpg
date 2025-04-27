local SceneManager = {}
SceneManager.__index = SceneManager

loaded_scenes = {}


function SceneManager:new(startScene, scenes)
    local sceneManager = {}
    setmetatable(sceneManager, SceneManager)
    loaded_scenes = scenes
    sceneManager.currentScene = startScene
    return sceneManager
    
end

return SceneManager