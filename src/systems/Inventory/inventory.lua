local Inventory = {}
Inventory.__index = Inventory


function Inventory:new()

    local inventory = {}
    setmetatable(inventory, Inventory)
    inventory.items = {
        itemsDB.getItem("Health pack")
    }
    inventory.max_weight = 100
    inventory.current_weight = 0
    inventory.isOpen = false
    inventory.selected_item = nil
    inventory.selected_item_index = 0
    inventory.item_info_open = false
    
    inventory_panel = {
        x = s.SCREEN_WIDTH/2 + 100,
        y = 0,
        width = s.SCREEN_WIDTH/2 / 0.5,
        height = s.SCREEN_HEIGHT,
        items_padding = 10
    }
    item_info_panel = {
        x = s.SCREEN_WIDTH/2 + 100,
        y = s.SCREEN_HEIGHT/2,
        width = 300,
        height = 400,
        items_padding = 10
    }
    item_info_buttons = {
        use = {
            x = item_info_panel.x + 10,
            y = item_info_panel.y + 10,
            width = 50,
            height = 20
        },
        drop = {
            x = item_info_panel.x + 70,
            y = item_info_panel.y + 40,
            width = 50,
            height = 20
        }
    }

    inventory.itemHeight = 40
    inventory.itemWidth = inventory_panel.width - inventory_panel.items_padding
    inventory.scrollY = -40

    return inventory
end

function Inventory:draw()
    if self.isOpen then 
        love.graphics.setColor(0.096, 0.09, 0.959, 0.9)
        love.graphics.rectangle("fill", inventory_panel.x, inventory_panel.y, inventory_panel.width, inventory_panel.height)


        love.graphics.setScissor(inventory_panel.x, inventory_panel.y, inventory_panel.width, inventory_panel.height)
        love.graphics.setColor(1, 1, 1)
        if #self.items == 0 then
            love.graphics.print("No items in inventory", inventory_panel.x + 10, inventory_panel.y + 40)
        else
            for i, item in ipairs(self.items) do
                local y = inventory_panel.y + (i-1) * self.itemHeight + self.scrollY

                if i == self.selected_item_index then
                    love.graphics.setColor(1, 1, 0)
                else
                    love.graphics.setColor(1, 1, 1)
                end
                love.graphics.print(item.name .. " - " .. item.weight .. "kg", inventory_panel.x + 10, y)
            end
        end
        love.graphics.setScissor()

        love.graphics.setColor(0.4, 0.4, 0.7, 1)
        love.graphics.rectangle("fill", inventory_panel.x, inventory_panel.y, inventory_panel.width, 40)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Inventory | Weight: "..self.current_weight.."/"..self.max_weight.."kg", inventory_panel.x + 10, inventory_panel.y + 7)


        love.graphics.setColor(1, 1, 1)
        love.graphics.print(self.scrollY, 10, 10)


        if self.item_info_open then
            love.graphics.setColor(0.396, 0.09, 0.659, 0.7)
            love.graphics.rectangle("fill", item_info_panel.x, item_info_panel.y, item_info_panel.width, item_info_panel.height)
            love.graphics.setColor(1, 1, 1)

            love.graphics.print("Item Info", item_info_panel.x + 10, item_info_panel.y + 10)
            love.graphics.print("Name: " .. self.selected_item.name, item_info_panel.x + 10, item_info_panel.y + 40)
            love.graphics.print("Weight: " .. self.selected_item.weight .. "kg", item_info_panel.x + 10, item_info_panel.y + 70)
            love.graphics.print("Description: " .. self.selected_item.description, item_info_panel.x + 10, item_info_panel.y + 100)
            love.graphics.setColor(1, 1, 1)

            -- use button
            if self.selected_item.usable then
                love.graphics.setColor(0.1, 0.7, 0.1, 1)
                love.graphics.rectangle("fill", item_info_buttons.use.x, item_info_buttons.use.y, item_info_buttons.use.width, item_info_buttons.use.height)
                love.graphics.setColor(1, 1, 1)
                love.graphics.print("Use", item_info_buttons.use.x + 175, item_info_buttons.use.y + 5)
            end

            -- drop button
            love.graphics.setColor(0.7, 0.1, 0.1, 1)
            love.graphics.rectangle("fill", item_info_buttons.drop.x, item_info_buttons.drop.y, item_info_buttons.drop.width, item_info_buttons.drop.height)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print("Drop", item_info_buttons.drop.x + 175, item_info_buttons.drop.y + 5)   

        end
    end
end

function Inventory:checkScroll()
    -- Minimum scroll position (top of the inventory)
    local minScroll = - math.max(80, #self.items * self.itemHeight - inventory_panel.height)

    -- Maximum scroll position (bottom of the inventory)
    local maxScroll = 40



    -- Clamp scrollY between minScroll and maxScroll
    if self.scrollY < minScroll then
        self.scrollY = minScroll
    end
    if self.scrollY > maxScroll then
        self.scrollY = maxScroll
    end

    -- Debugging
    print("scrollY:", self.scrollY, "minScroll:", minScroll, "maxScroll:", maxScroll)
end

function Inventory:OpenCloseInventory()
    if self.isOpen then
        self.scrollY = 40
        self.selected_item = nil
        self.selected_item_index = 0
        self.item_info_open = false
    end
    self.isOpen = not self.isOpen
    self.scrollY = 40

end

function Inventory:UpdateAfterChangeOfResolution()
    inventory_panel.x = s.SCREEN_WIDTH - 350
    inventory_panel.y = 0
    inventory_panel.width = 350
    inventory_panel.height = s.SCREEN_HEIGHT

    item_info_panel.x = inventory_panel.x - 400
    item_info_panel.y = s.SCREEN_HEIGHT * 0.05
    item_info_panel.width = 400
    item_info_panel.height = s.SCREEN_HEIGHT * 0.9


    for i, button in pairs(item_info_buttons) do
        button.width = 400 - 20
        button.height = 40
    end
    item_info_buttons.use.x = item_info_panel.x + 10
    item_info_buttons.use.y = item_info_panel.height - 60
    item_info_buttons.drop.x = item_info_panel.x + 10
    item_info_buttons.drop.y = item_info_panel.height - 10
    
end

function Inventory:mouse(x,y)
    if #self.items == 0 then
        return
    end
    if self.item_info_open then
        for _, button in pairs(item_info_buttons) do
            if x > button.x and x < button.x + button.width then
                if y > button.y and y < button.y + button.height then
                    if button == item_info_buttons.use and self.selected_item.usable then
                        self.selected_item:use()
                        self.current_weight = self.current_weight - self.selected_item.weight
                        if self.current_weight < 0 then
                            self.current_weight = 0
                        end
                        self.items[self.selected_item_index] = nil
                        self:CloseInventoryInfo()

                    end
                    if button == item_info_buttons.drop then
                        self.current_weight = self.current_weight - self.selected_item.weight
                        if self.current_weight < 0 then
                            self.current_weight = 0
                        end
                        table.remove(self.items, self.selected_item_index)
                        self.selected_item = nil
                        self.selected_item_index = 0
                        self:CloseInventoryInfo()
                    end
                end
            end
        end
    end
    for i, item in ipairs(self.items) do
        local itemY = inventory_panel.y + (i-1) * self.itemHeight + self.scrollY
        local itemX = inventory_panel.x + inventory_panel.items_padding

        if x > itemX and x < itemX + self.itemWidth then
            if y > itemY and y < itemY + self.itemHeight then
                if self.selected_item_index == i then
                    self.selected_item = nil
                    self.selected_item_index = 0
                    self:CloseInventoryInfo()
                else
                    self.selected_item = item
                    self.selected_item_index = i
                    self:OpenInventoryInfo()
                end
                
                break
            end
        end
    end
end

function Inventory:OpenInventoryInfo()    
    self.item_info_open = true
end

function Inventory:CloseInventoryInfo()
    self.item_info_open = false
end


function Inventory:IsOverWeight()
    if self.current_weight > self.max_weight then
        return true
    else
        return false
    end
end

return Inventory