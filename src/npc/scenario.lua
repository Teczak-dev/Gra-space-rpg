local Scenario = {}
Scenario.__index = Scenario

Npcs = {}
local function scenario_planet_001()
    Npcs = { NPC:new(6900 , 4580,"Stranger", {
            {
                person = "Player",
                dialog = "Hey, what are you doing here?",
                time = 2,
                isOption = false
            },

            {
                person = "NPC",
                dialog = "I'm just a simple NPC, trying to make my way in the world.",
                time = 2,
                isOption = false
            },

            {
                person = "Player",
                dialog = "Well, you should be careful. There are dangerous things out there.",
                time = 2,
                isOption = false
            },

            {
                person = "NPC",
                dialog = "I know, but I have to keep moving forward.",
                time = 2,
                isOption = false
            },
            
            {
                person = "Player",
                dialog = "I understand. Just be careful.",
                time = 2,
                isOption = false
            },
            
            {
                person = "NPC",
                dialog = "I will. Thanks for the warning.",
                time = 2,
                isOption = false
            },
            
            {
                person = "Player",
                dialog = "No problem. Good luck out there.",
                time = 2,
                isOption = false
            },
            
            {
                person = "NPC",
                dialog = "Thanks! You too!",
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