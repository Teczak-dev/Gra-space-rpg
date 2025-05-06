local Npc = {}
Npc.__index = Npc

function Npc:new(x,y, dialogues)
    local npc = {}
    setmetatable(npc, Npc)
    npc.sprite = love.graphics.newImage("assets/sprites/character.png") 
    npc.x = x
    npc.y = y
    npc.dialogues = dialogues
    npc.width = 48
    npc.height = 64
    npc.body = love.physics.newBody(world, npc.x, npc.y, "static")
    npc.shape = love.physics.newRectangleShape(npc.width*1.3,npc.height/2+7,npc.width, npc.height)
    npc.fixture = love.physics.newFixture(npc.body, npc.shape)
    npc.body:setFixedRotation(true)

    return npc
end

function Npc:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite, self.x, self.y, 0, 2, 2)
end

return Npc