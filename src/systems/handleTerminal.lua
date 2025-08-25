local HandleTerminal = {}
HandleTerminal.__index = HandleTerminal

function HandleTerminal:new()
    local terminal = {}
    setmetatable(terminal, HandleTerminal)
    terminal.isOpen = false
    
    terminal.main_panel = {
        x = 0,
        y = 0,
        width = 0,
        height = 0
    }

    terminal.text_buttons = {
        inventory = {
            x = 100 + terminal.main_panel.x,
            y = 100 + terminal.main_panel.y,
            width = 200,
            height = 50,
            label = "Inventory",
            use_function = function ()
                
            end
        },
        skills = {
            x = 100 + terminal.main_panel.x,
            y = 200 + terminal.main_panel.y,
            width = 200,
            height = 50,
            label = "Skills",
            use_function = nil
        },
        crafting = {
            x = 100 + terminal.main_panel.x,
            y = 300 + terminal.main_panel.y,
            width = 200,
            height = 50,
            label = "Crafting",
            use_function = nil
        },
        logs = {
            x = 100 + terminal.main_panel.x,
            y = 400 + terminal.main_panel.y,
            width = 200,
            height = 50,
            label = "Logs",
            use_function = nil
        },
        equipment = {
            x = 100 + terminal.main_panel.x,
            y = 500 + terminal.main_panel.y,
            width = 200,
            height = 50,
            label = "Equipment",
            use_function = nil
        }
    }

    return terminal
end

function HandleTerminal:draw()
    if self.isOpen then 
        love.graphics.setColor(0.096, 0.09, 0.959, 0.9)
        love.graphics.rectangle("fill", self.main_panel.x, self.main_panel.y, self.main_panel.width, self.main_panel.height)

    for index, value in pairs(self.text_buttons) do
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.rectangle("fill", value.x, value.y, value.width, value.height)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(value.label, value.x + 10, value.y + 10)
        end

    end
    
end

function HandleTerminal:update(dt)
    
end
function HandleTerminal:UpdateAfterChangeOfResolution()
    self.main_panel.x = s.SCREEN_WIDTH / 2 - 350
    self.main_panel.y = s.SCREEN_HEIGHT / 2 - 300
    self.main_panel.width = 700
    self.main_panel.height = 600



    -- Update other UI elements if necessary

    for index, value in pairs(self.text_buttons) do
        if index == "inventory" then
            value.x = 100 + self.main_panel.x
            value.y = 200 + self.main_panel.y
        elseif index == "skills" then
            value.x = 100 + self.main_panel.x
            value.y = 300 + self.main_panel.y
        elseif index == "crafting" then
            value.x = 100 + self.main_panel.x
            value.y = 400 + self.main_panel.y
        elseif index == "logs" then
            value.x = 400 + self.main_panel.x
            value.y = 200 + self.main_panel.y
        elseif index == "equipment" then
            value.x = 400 + self.main_panel.x
            value.y = 300 + self.main_panel.y
        end
    end
end

function HandleTerminal:mouse()

    local mouseX, mouseY = love.mouse.getPosition()

    for index, value in pairs(self.text_buttons) do
        if mouseX >= value.x and mouseX <= value.x + value.width and
           mouseY >= value.y and mouseY <= value.y + value.height then
            value.use_function()
        end
    end

end

return HandleTerminal