local Item = {}
Item.__index = Item

function Item:new(name, description, type, image, value, weight, usable)
    local item = {}
    setmetatable(item, Item)
    item.name = name
    item.description = description
    item.type = type
    --item.image = love.graphics.newImage(image)
    item.value = value
    item.max_stack = 99
    item.weight = weight
    item.use = function()
        print("Using item: " .. name)
    end
    item.usable = usable or false -- Default to false if not specified
    return item
end

return Item