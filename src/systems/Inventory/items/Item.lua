local Item = {}
Item.__index = Item

function Item:new(name, description, type, image, value)
    local item = {}
    setmetatable(item, Item)
    item.name = name
    item.description = description
    item.type = type
    item.image = image
    item.value = value
    return item
end

return Item