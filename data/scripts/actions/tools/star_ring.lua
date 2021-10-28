local starRing = Action()
function starRing.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local amulet = player:getSlotItem(CONST_SLOT_RING)
    if amulet ~= item or amulet ~= item then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to equip the ring to try use it.")
        return true
    end
    if item.itemid == 13826 then
        if math.random(2) == 1 then
            player:addHealth(250, true, true)
            player:sendTextMessage(
                MESSAGE_EVENT_ADVANCE,
                "Magical sparks whirl around the ring as you use it and you was healed."
            )
        else
            local condition = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)

            player:feed(900 - (condition:getTicks() / 1000))
            player:sendTextMessage(
                MESSAGE_EVENT_ADVANCE,
                "Magical sparks whirl around the ring as you use it and you feel satisfied."
            )
        end
        item:transform(13825)
        item:decay()
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        return true
    elseif item.itemid == 13825 then
        player:sendTextMessage(
            MESSAGE_EVENT_ADVANCE,
            "The ring is gathering energy to recharge, you must wait for it to complete."
        )
    end
    return true
end

starRing:id(13825, 13826)
starRing:register()
