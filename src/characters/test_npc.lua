local Npc = {}
Npc.__index = Npc

function Npc:new(x,y, dialogues)
    local npc = {}
    setmetatable(npc, Npc)
    self.sprite = love.graphics.newImage("assets/sprites/character2.png") 
    self.x = x
    self.y = y
    self.dialogues = dialogues
    self.width = 64-16
    self.height = 64
    self.body = love.physics.newBody(world, self.x, self.y, "static")
    self.shape = love.physics.newRectangleShape(self.width*1.3,self.height/2+7,self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.body:setFixedRotation(true)

    return npc
end

function Npc:draw()
    love.graphics.draw(self.sprite, self.x, self.y, 0, 2,2)
end

return Npc