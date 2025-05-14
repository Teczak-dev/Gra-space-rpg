HealthItem = require 'src/systems/Inventory/items/HealthItem'

local ItemsDB = {}
ItemsDB.__index = ItemsDB


function ItemsDB:new()
    local itemsdb = {}
    setmetatable(itemsdb, ItemsDB)
    itemsdb.items = {
        HealthItem:new("Health pack", "Restores 50 HP", "health", nil, 10, 0.5, 50) 
    }

    itemsdb.getItem = function(name)
        for _, item in ipairs(itemsdb.items) do
            if item.name == name then
                return item
            end
        end
        return nil
    end

    return itemsdb
    
end

return ItemsDB