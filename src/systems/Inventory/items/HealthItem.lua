local Item = require 'src/systems/Inventory/items/Item'

-- HealthItem class
local HealthItem = {}
HealthItem.__index = HealthItem

function HealthItem:new(name, description, type, image, value, weight, health_amount, usable)
    local health_item = Item:new(name, description, type, image, value, weight, usable)
    setmetatable(health_item, HealthItem)
    
    health_item.heal_amount = health_amount
    health_item.use = function ()
        player.hp = player.hp + health_item.heal_amount
        if player.hp > player.maxhp then
            player.hp = player.maxhp
        end
    end

    return health_item
end

return HealthItem