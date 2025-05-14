local Pickup = {}
Pickup.__index = Pickup

function Pickup:new(item, x, y)
    local pickup = {}
    setmetatable(pickup, Pickup)
    pickup.item = item
    pickup.x = x
    pickup.y = y
    pickup.width = 32
    pickup.height = 32
    pickup.IsInRange = false

    pickup.body = love.physics.newBody(world, pickup.x, pickup.y, "static")
    pickup.shape = love.physics.newRectangleShape(pickup.width , pickup.height ,pickup.width, pickup.height)
    pickup.fixture = love.physics.newFixture(pickup.body, pickup.shape)
    pickup.fixture:setSensor(true)
    pickup.canDelete = false

    return pickup
end

function Pickup:update(dt , i)
    if player.fixture ~= nil then
        if love.physics.getDistance(player.fixture, self.fixture) <= self.width*2 then
            self.IsInRange = true
            local info = "Press E to pick up ".. self.item.name
            playerUI:showText(info)
            
            if love.keyboard.isDown("e") then
                playerUI.interaction_Text = ""

                table.insert(inventory.items, self.item)
            
                inventory.current_weight = inventory.current_weight + self.item.weight
                removeBody(self.body)
                self.canDelete = true
                self.IsInRange = false
            end
            

            
        else
            if playerUI.interaction_Text ~= "" and self.IsInRange then
                playerUI.interaction_Text = ""
                self.IsInRange = false
            end
        end

    end
end

function Pickup:draw()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", self.x + self.width/2, self.y + self.height/2, self.width, self.height)
end

return Pickup