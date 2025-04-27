local Pause = {}
Pause.__index = Pause


local pause_width,pause_height = 200,200
local pause_x = SCREEN_WIDTH/2 - pause_width/2
local pause_y = SCREEN_HEIGHT/2 - pause_height/2
margin = 10
resume_rectangle = {fill ="fill", 
                        x = pause_x + margin,
                        y = pause_y+10, 
                        w = 180,
                        h = 50}
options_rectangle = {fill ="fill", 
                        x = pause_x + margin,
                        y = pause_y + 50 + margin*2 ,
                        w = 180,
                        h = 50}
exit_rectangle = {fill ="fill", 
                    x = pause_x + margin,
                    y = pause_y + 100 + margin*3, 
                    w = 180,
                    h = 50}

function Pause:new()
    local pause = {}
    setmetatable(pause, Pause)
    pause.isPaused = false

    return pause
    
end

function Pause:pause()
    if not self.isPaused then
        player.canMove = false
        self.isPaused = true
    end
end
function Pause:resume()
    if self.isPaused then
        self.isPaused = false
        player.canMove = true
    end
end

function Pause:mouse(x,y)
    -- resume button detection if mouse is clicked
    if x > resume_rectangle.x and x < resume_rectangle.x + resume_rectangle.w then
        if y > resume_rectangle.y and y < resume_rectangle.y + resume_rectangle.h then
            self:resume()
        end
    end

    if x > options_rectangle.x and x < options_rectangle.x + options_rectangle.w then
        if y > options_rectangle.y and y < options_rectangle.y + options_rectangle.h then
            self:resume()
        end
    end

    -- exit button detection if mouse is clicked
    if x > exit_rectangle.x and x < exit_rectangle.x + exit_rectangle.w then
        if y > exit_rectangle.y and y < exit_rectangle.y + exit_rectangle.h then
            love.event.quit()
        end
    end
end

function Pause:draw()
    if self.isPaused then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", pause_x, pause_y, pause_width, pause_height )
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("PAUSED", pause_x+20, pause_y-25)

        -- resume button
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle(resume_rectangle.fill, resume_rectangle.x, resume_rectangle.y, resume_rectangle.w, resume_rectangle.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Resume", resume_rectangle.x + 10, resume_rectangle.y + 10)
        
        -- options button
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle(options_rectangle.fill, options_rectangle.x, options_rectangle.y, options_rectangle.w, options_rectangle.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Options", options_rectangle.x + 10, options_rectangle.y + 10)
        
        
        -- exit button
        love.graphics.setColor(0.3, 0.3, 0.3)
        love.graphics.rectangle(exit_rectangle.fill, exit_rectangle.x, exit_rectangle.y, exit_rectangle.w, exit_rectangle.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Exit", exit_rectangle.x + 10, exit_rectangle.y + 10)
        

    end
end

return Pause