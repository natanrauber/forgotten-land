local starRing = Action()
function starRing.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local amulet = player:getSlotItem(CONST_SLOT_RING)
    local condition = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
    if amulet ~= item or amulet ~= item then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to equip the ring to try use it.")
        return true
    end
    if item.itemid == 13826 then
        local chance = math.random(10)
        player:addHealth(chance * 30, true, true)
        player:sendTextMessage(
            MESSAGE_EVENT_ADVANCE,
            "Magical sparks whirl around the ring as you use it and you was healed."
        )
        if (condition:getTicks() / 1000) < 350 then
            player:feed(350 - (condition:getTicks() / 1000))
        end
        item:transform(13825)
        item:decay()
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        return true
    elseif item.itemid == 13825 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The ring is gathering energy to recharge.")
    end
    return true
end

starRing:id(13825, 13826)
starRing:register()
