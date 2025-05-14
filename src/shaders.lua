local night_shader = [[
    // extern vec2 player_position; // Player's position in screen coordinates
    //extern float light_radius;   // Radius of the light around the player

    extern vec2 light_position[10]; // Light's position in screen coordinates
    extern float light_radius[10];  // Radius of the light around the player

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        vec4 texel = Texel(texture, texture_coords) * color;
        float alpha = 0.0;

        // Loop through all light sources
        for (int i = 0; i < 10; i++) {
            float distance = distance(screen_coords, light_position[i]);
            float light_alpha = 1.0 - smoothstep(light_radius[i] * 0.8, light_radius[i], distance);
            alpha = max(alpha, light_alpha); // Combine light effects
        }

        // If the pixel is within any light radius, keep it bright; otherwise, darken it
        if (alpha > 0.0) {
            return vec4(texel.rgb, texel.a * alpha); // Bright pixel with transparency
        } else {
            return vec4(texel.rgb, texel.a * 0.1); // Fully dark pixel
        }
    }
]]


local Shaders = {}
Shaders.__index = Shaders

function Shaders:new()
    local self = setmetatable({}, Shaders)
    
    self.night_shader = love.graphics.newShader(night_shader)
    self.lights = {}
    self.light_radius = {}

    -- Add the player's light as the first light source
    local playerX, playerY = cam:cameraCoords(player.x, player.y)
    table.insert(self.lights, {playerX + player.width / 2, playerY + player.height / 2})
    table.insert(self.light_radius, player.light_radius or 200)

    -- Add NPC lights
    for _, npc in ipairs(Npcs) do
        local npcX, npcY = cam:cameraCoords(npc.x, npc.y)
        table.insert(self.lights, {npcX + npc.width / 2, npcY + npc.height / 2})
        table.insert(self.light_radius, 200) -- Default radius for NPC lights
    end

    return self
end

function Shaders:update(dt)
    -- Update the player's light position
    local playerX, playerY = cam:cameraCoords(player.x, player.y)
    self.lights[1] = {playerX + player.width / 2, playerY + player.height / 2}
    self.light_radius[1] = player.light_radius or 200

    -- Update NPC light positions
    for i, npc in ipairs(Npcs) do
        local npcX, npcY = cam:cameraCoords(npc.x, npc.y)
        self.lights[i + 1] = {npcX + npc.width / 2, npcY + npc.height / 2}
        self.light_radius[i + 1] = 200 -- Default radius for NPC lights
    end

    -- Send light data to the shader
    self.night_shader:send("light_position", unpack(self.lights))
    self.night_shader:send("light_radius", unpack(self.light_radius))
end
function Shaders:draw()
    if not time.isDay then
        love.graphics.setShader(shaders.night_shader)
    end
end

return Shaders