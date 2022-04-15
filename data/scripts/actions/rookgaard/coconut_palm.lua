local coconutPalm = Action()

function coconutPalm.onUse(player)
    if player:getStorageValue(Storage.QuestChests.CoconutPalm) < os.time() then
        local chance = math.random(100)
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        if chance >= 30 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a coconut.")
            player:addItem(2678, 1)
        elseif chance < 30 and chance >= 25 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found two coconuts.")
            player:addItem(2678, 2)
        elseif chance < 25 and chance >= 22 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found three coconuts.")
            player:addItem(2678, 3)
        end
        player:setStorageValue(Storage.QuestChests.CoconutPalm, os.time() + 3600)
    end
    return true
end

coconutPalm:id(2726)
coconutPalm:register()
