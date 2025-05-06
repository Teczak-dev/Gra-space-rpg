local Scenario = {}
Scenario.__index = Scenario

Npcs = {}
local function scenario_planet_001()
    Npcs = { NPC:new(6900 , 4580, {
            {
                dialog = "Player: Hey, what are you doing here?",
                time = 2,
                isOption = false
            },

            {
                dialog = "NPC: I'm just a simple NPC, trying to make my way in the world.",
                time = 2,
                isOption = false
            },

            {
                dialog = "Player: Well, you should be careful. There are dangerous things out there.",
                time = 2,
                isOption = false
            },

            {
                dialog = "NPC: I know, but I have to keep moving forward.",
                time = 2,
                isOption = false
            },
            
            {
                dialog = "Player: I understand. Just be careful.",
                time = 2,
                isOption = false
            },
            
            {
                dialog = "NPC: I will. Thanks for the warning.",
                time = 2,
                isOption = false
            },
            
            {
                dialog = "Player: No problem. Good luck out there.",
                time = 2,
                isOption = false
            },
            
            {
                dialog = "NPC: Thanks! You too!",
                time = 2,
                isOption = false
            }
        }
    )}
end

function Scenario:new(loc)
    local scenario = {}
    setmetatable(scenario, Scenario)
    scenario:ChangeScenario(loc)
    return scenario
end
function Scenario:ChangeScenario(loc)
    if loc == "planet_001" then
        scenario_planet_001()
    end
end


return Scenario