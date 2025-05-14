local Time = {}
Time.__index = Time


function Time:new()
    local time = {}
    setmetatable(time, Time)
    time.time = 0
    time.isDay = true
    time.dayTime = 1000
    time.nightTime = 1500
    return time
end

function Time:update(dt)

    if not pause.isPaused then
        self.time = self.time + dt * 10
    end

    if self.time > self.dayTime then
        self.isDay = false
    end
    if self.time > self.nightTime then
        self.isDay = true
        self.time = self.time - self.nightTime
    end
end

return Time