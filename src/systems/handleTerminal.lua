local HandleTerminal = {}
HandleTerminal.__index = HandleTerminal

function HandleTerminal:new()
    local terminal = {}
    setmetatable(terminal, HandleTerminal)
    terminal.isOpen = false
    
    terminal.main_panel = {
        x = s.SCREEN_WIDTH / 2 + 100,
        y = 0,
        width = s.SCREEN_WIDTH / 2 / 0.5,
        height = s.SCREEN_HEIGHT,
        items_padding = 10
    }

    return terminal
end

function HandleTerminal:draw()
    if self.isOpen then 
        love.graphics.setColor(0.396, 0.09, 0.659, 0.9)
        love.graphics.rectangle("fill", self.main_panel.x, self.main_panel.y, self.main_panel.width, self.main_panel.height)
    end
    
end

function HandleTerminal:update(dt)
    
end

return HandleTerminal