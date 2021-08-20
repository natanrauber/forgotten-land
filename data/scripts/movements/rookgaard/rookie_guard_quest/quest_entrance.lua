function onStepIn(player, item, position, fromPosition)
    
    local t = Position(31980, 32173, 10)
    
    if player:getLevel() < 35 then
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "You need to be at least level 35 to use this teleport!")
        return true
    else
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:teleportTo(t)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You entered Kraknaknork's challenge!")
    end
    
    return true
end
