local Item = require 'src/systems/Inventory/items/Item'
local HealthItem = setmetatable({}, {__index = Item})
HealthItem.__index = HealthItem

function HealthItem:new(name, description, type, image, value, health_amount)
    local health_item = Item:new(name, description, type, image, value)
    setmetatable(health_item, HealthItem)
    health_item.heal_amount = health_amount
    return health_item
end

return HealthItem