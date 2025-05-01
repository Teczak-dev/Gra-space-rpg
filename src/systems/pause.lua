--[[
    * Pause system
    * This system handles the pause menu in the game.
    * It allows the player to pause the game and access options or exit.
]]
local Pause = {}
Pause.__index = Pause
    

local dragging = false

-- Setup variables
local pause_width,pause_height = 200,190
local pause_x = s.SCREEN_WIDTH /2 - pause_width/2
local pause_y = s.SCREEN_HEIGHT /2 - pause_height/2
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


-- Options menu
local options = {
    x = pause_x - 100, y = pause_y - 150, w = 400, h = 500
}
local options_exit_button = {
    x = options.x + 10, y = options.y + 10, w = 40, h = 40
}
local setFullscreen_button = { x = options.x+options.w - 50, y = options_exit_button.y + 50, w = 30, h = 30 }

local res_left_button = {x = options.x + 12, y = setFullscreen_button.y + 100, w = 30, h = 30}
local res_right_button = {x = options.x + 200, y = setFullscreen_button.y + 100, w = 30, h = 30}
local res_apply_button = {x = options.x + 200 + res_right_button.w + 10, y = setFullscreen_button.y + 100, w = 80, h = 30}

local volume_slider = {
    x = options.x + 12,
    y = res_apply_button.y + res_apply_button.h + 20,
    w = 180,
    h = 20,
    value = s.volume, -- początkowa wartość głośności (0.0 - 1.0)
}



function Pause:new()
    local pause = {}
    setmetatable(pause, Pause)
    pause.isPaused = false
    pause.isOptions = false
    return pause
    
end
function Pause:SetDragging()
    dragging = false
end

-- ! MOUSE CLICK
function Pause:mouse(x,y)
    --! OPTIONS CLICK LOGIC
    if self.isOptions then

        print("Options")
        if x > options_exit_button.x and x < options_exit_button.x + options_exit_button.w then
            if y > options_exit_button.y and y < options_exit_button.y + options_exit_button.h then
                self:Options()
            end
        end

        if x > setFullscreen_button.x and x < setFullscreen_button.x + setFullscreen_button.w then
            if y > setFullscreen_button.y and y < setFullscreen_button.y + setFullscreen_button.h then
                s:toggleFullscreen()
            end
        end

        -- left button
        if x > res_left_button.x and x < res_left_button.x + res_left_button.w and
            y > res_left_button.y and y < res_left_button.y + res_left_button.h then
                s.current_resolution = s.current_resolution + 1
                if s.current_resolution > #s.resolutions then s.current_resolution = 1 end
        end

        -- right button
        if x > res_right_button.x and x < res_right_button.x + res_right_button.w and
            y > res_right_button.y and y < res_right_button.y + res_right_button.h then
                s.current_resolution = s.current_resolution - 1
                if s.current_resolution < 1 then s.current_resolution = #s.resolutions end
        end

        -- apply button
        if x > res_apply_button.x and x < res_apply_button.x + res_apply_button.w and
            y > res_apply_button.y and y < res_apply_button.y + res_apply_button.h then
                --local res = s.resolutions[s.current_resolution]
                s:toggleWindow()
        end

        if x > volume_slider.x and x < volume_slider.x + volume_slider.w and
        y > volume_slider.y and y < volume_slider.y + volume_slider.h then
            dragging = true
            -- Oblicz wartość głośności na podstawie pozycji myszy
            volume_slider.value = (x - volume_slider.x) / volume_slider.w
            love.audio.setVolume(volume_slider.value)
        else
            dragging = false
        end


        
    else
        if x > resume_rectangle.x and x < resume_rectangle.x + resume_rectangle.w then
            if y > resume_rectangle.y and y < resume_rectangle.y + resume_rectangle.h then
                self:resume()
            end
        end

        if x > options_rectangle.x and x < options_rectangle.x + options_rectangle.w then
            if y > options_rectangle.y and y < options_rectangle.y + options_rectangle.h then
                self:Options()
            end
        end

        -- exit button detection if mouse is clicked
        if x > exit_rectangle.x and x < exit_rectangle.x + exit_rectangle.w then
            if y > exit_rectangle.y and y < exit_rectangle.y + exit_rectangle.h then
                love.event.quit()
            end
        end
    end
end

function Pause:draw()
    if self.isPaused then
        self:draw_pause()
        if self.isOptions then
            self:draw_options()
        end
    end
end

-- ! UPDATE OPTIONS MENU ( CHANGE VOLUME IF PLAYER DRAGGING THE SLIDER )
function Pause:update(dt)
    if dragging then
        local mx, my = love.mouse.getPosition()
        -- Oblicz wartość głośności na podstawie pozycji myszy
        volume_slider.value = (mx - volume_slider.x) / volume_slider.w
        -- Ogranicz wartość głośności do zakresu 0.0-1.0
        volume_slider.value = math.min(1, math.max(0, volume_slider.value))
        love.audio.setVolume(volume_slider.value)
    end
end

-- ! DRAW OPTIONS MENU
function Pause:draw_options()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", options.x, options.y, options.w, options.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Options", options.x + 20, options.y - 25)

    --draw exit options button
    love.graphics.setColor(1, 0.2, 0.2)
    love.graphics.rectangle("fill", options_exit_button.x, options_exit_button.y, options_exit_button.w, options_exit_button.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("X", options_exit_button.x + 12, options_exit_button.y + 7)

    --*draw fullscreen button
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Fullscreen:", options.x + 12, setFullscreen_button.y)
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", setFullscreen_button.x, setFullscreen_button.y, setFullscreen_button.w, setFullscreen_button.h)
    if s.IS_FULLSCREEN then
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.rectangle("fill", setFullscreen_button.x+5, setFullscreen_button.y+5, setFullscreen_button.w-10, setFullscreen_button.h-10) 
    end
    local currentWidth, currentHeight = love.graphics.getDimensions()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Resolution: " .. currentWidth .. "x" .. currentHeight, options.x + 12, setFullscreen_button.y + 50)

    -- show selected resolution from list
    local selectedRes = s.resolutions[s.current_resolution]
    love.graphics.print(selectedRes.width .. "x" .. selectedRes.height, res_left_button.x + res_left_button.w +  12, res_left_button.y + 2)

    --* draw arrows and apply
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", res_left_button.x, res_left_button.y, res_left_button.w, res_left_button.h)
    love.graphics.rectangle("fill", res_right_button.x, res_right_button.y, res_right_button.w, res_right_button.h)
    love.graphics.rectangle("fill", res_apply_button.x, res_apply_button.y, res_apply_button.w, res_apply_button.h)
    love.graphics.setColor(1,1,1)
    love.graphics.print("<", res_left_button.x + 5, res_left_button.y + 2)
    love.graphics.print(">", res_right_button.x + 5, res_right_button.y + 2)
    love.graphics.print("Apply", res_apply_button.x + 5, res_apply_button.y + 2)



    --* draw volume slider
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", volume_slider.x, volume_slider.y+3, volume_slider.w, volume_slider.h)

    -- Rysowanie uchwytu suwaka
    local slider_pos = volume_slider.x + volume_slider.value * volume_slider.w
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", slider_pos, volume_slider.y + volume_slider.h / 2 + 3, 10)

    -- Wyświetlanie aktualnej głośności
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Volume: " .. math.floor(volume_slider.value * 100) .. "%", volume_slider.x + volume_slider.w + 10, volume_slider.y)

end
-- ! DRAW PAUSE MENU
function Pause:draw_pause()
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



-- ! LOGIC
function Pause:Options()
    self.isOptions = not self.isOptions
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



-- ! RECREATING OBJECTS FOR SCREEN RESOLUTION CHANGE
function Pause:recreatingObjects()
    -- Setup variables
    pause_width,pause_height = 200,190
    pause_x = s.SCREEN_WIDTH /2 - pause_width/2
    pause_y = s.SCREEN_HEIGHT /2 - pause_height/2
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


    -- Options menu
    options = {
        x = pause_x - 100, y = pause_y - 150, w = 400, h = 500
    }
    options_exit_button = {
        x = options.x + 10, y = options.y + 10, w = 40, h = 40
    }
    setFullscreen_button = { x = options.x+options.w - 50, y = options_exit_button.y + 50, w = 30, h = 30 }

    res_left_button = {x = options.x + 12, y = setFullscreen_button.y + 100, w = 30, h = 30}
    res_right_button = {x = options.x + 200, y = setFullscreen_button.y + 100, w = 30, h = 30}
    res_apply_button = {x = options.x + 200 + res_right_button.w + 10, y = setFullscreen_button.y + 100, w = 80, h = 30}

    volume_slider = {
        x = options.x + 12,
        y = res_apply_button.y + res_apply_button.h + 20,
        w = 180,
        h = 20,
        value = s.volume, -- początkowa wartość głośności (0.0 - 1.0)
    }
end

return Pause