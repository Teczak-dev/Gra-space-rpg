local TalkSys = {}
TalkSys.__index = TalkSys

function TalkSys:new()
    local talksys = {}
    setmetatable(talksys, TalkSys)
    talksys.dialogues = {}
    talksys.text = ""
    talksys.npc = nil
    talksys.font = love.graphics.newFont(25)
    talksys.isTalking = false
    talksys.canTalk = true
    talksys.distance_to_talk = 50
    talksys.talk_time = 0
    talksys.person = ""
    return talksys
end

local function copyTable(orig)
    local copy = {}
    for i, v in ipairs(orig) do
        copy[i] = v
    end
    return copy
end

function TalkSys:update(dt)
    if self.isTalking then
        if not self.dialogues[1].isOption then
            self.talk_time = self.talk_time + dt
        end
        self.text = self.dialogues[1].dialog
        self.person = self.dialogues[1].person
        if self.talk_time >= self.dialogues[1].time then
            table.remove(self.dialogues, 1)
            self.talk_time = 0
        end

        if #self.dialogues == 0 then
            self.isTalking = false
            player.canMove = true
            pause.canPause = true
            self.canTalk = true
        end
    else
        for i, npc in ipairs(Npcs) do
            if love.physics.getDistance(player.fixture, npc.fixture) <= self.distance_to_talk  then
                self.npc = npc
                self.canTalk = true
                local info = "Press E to talk to "
                playerUI:showText(info)
                break
            else
                if playerUI.interaction_Text ~= "" and self.canTalk then
                    playerUI.interaction_Text = ""
                end
                self.canTalk = false
            end
        end
        if self.canTalk and love.keyboard.isDown("e") then
            self.isTalking = true
            player.canMove = false
            self.canTalk = false
            pause.canPause = false
            self.dialogues = copyTable(self.npc.dialogues)
            playerUI.interaction_Text = ""
        end
    end
end

function TalkSys:draw()
    if self.isTalking then
        love.graphics.setFont(self.font)

        love.graphics.setColor(1,1,1)
        if self.person == "Player" then
            love.graphics.draw(player.sprite, 0 - 64,  love.graphics.getHeight() - 190, 0 , 4)
        elseif self.person == "NPC" then
            love.graphics.draw(self.npc.sprite, s.SCREEN_WIDTH - 64* 3,  love.graphics.getHeight() - 190, 0 , 4)
        end

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", 10, love.graphics.getHeight() - 100, love.graphics.getWidth() - 20, 90)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(self.text, self.font, 20, love.graphics.getHeight() - 90, love.graphics.getWidth() - 40, "left")

    end
end

return TalkSys