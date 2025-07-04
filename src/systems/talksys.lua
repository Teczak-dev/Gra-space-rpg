local TalkSys = {}
TalkSys.__index = TalkSys

function TalkSys:new()
    local talksys = {}
    setmetatable(talksys, TalkSys)
    talksys.dialogues = {}
    talksys.text = ""
    talksys.npc = nil
    talksys.font = love.graphics.newFont(25)
    talksys.font2 = love.graphics.newFont(35)
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
        
        local sprite = nil
        if self.person == "Player" then
            love.graphics.draw(player.sprite, 0 - 128,  love.graphics.getHeight() - 330, 0 , 8)
        elseif self.person == "NPC" then
            love.graphics.draw(self.npc.sprite, 0 - 128,  love.graphics.getHeight() - 330, 0 , 8)
        end

        
        love.graphics.setColor(0, 0, 0, 1)
        local dialog_bg = {
            x = love.graphics.getWidth() - ( love.graphics.getWidth() - 300) - 20,
            y = love.graphics.getHeight() - 300 - 20,
            w = love.graphics.getWidth() - 300,
            h = 300
        }
        love.graphics.rectangle("fill", dialog_bg.x , dialog_bg.y, dialog_bg.w, dialog_bg.h)
        love.graphics.setColor(0.9,0.9,0.9)
        if self.person ~= "Player" then
            love.graphics.printf(self.npc.name, self.font2, dialog_bg.x + 10, dialog_bg.y + 10, dialog_bg.w - 20, "left")
        else
            love.graphics.printf(self.person, self.font2, dialog_bg.x + 10, dialog_bg.y + 10, dialog_bg.w - 20, "left")
        end
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(self.text, self.font, dialog_bg.x + 10, dialog_bg.y + 60, dialog_bg.w - 20, "left")

    end
end

return TalkSys