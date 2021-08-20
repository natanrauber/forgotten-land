function onStepIn(player, item, position, fromPosition)
    
    local t = Position(31933, 32170, 11)
    local corpsePos = Position(31932, 32166, 10)
    local corpse = Tile(corpsePos):getItemById(2860)
    
    if corpse then
        corpse:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
        corpse:remove()
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:teleportTo(t)
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    else
        doSendMagicEffect(corpsePos, CONST_ME_POFF)
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Something went wrong!")
    end
end
