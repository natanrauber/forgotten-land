local pos1 = Position(31989, 32068, 8)
local pos2 = Position(31990, 32068, 8)
local relocatePos1 = Position(31989, 32068, 9)
local relocatePos2 = Position(31990, 32068, 9)

local floorPos1 = Position(31989, 32067, 8)
local floorPos2 = Position(31990, 32067, 8)
local floorPos3 = Position(31991, 32067, 8)

local floorPos4 = Position(31988, 32068, 8)
local floorPos5 = Position(31989, 32068, 8)
local floorPos6 = Position(31990, 32068, 8)
local floorPos7 = Position(31991, 32068, 8)

local floorPos8 = Position(31988, 32069, 8)
local floorPos9 = Position(31989, 32069, 8)
local floorPos10 = Position(31990, 32069, 8)

local poisonSpiderCaveFloor = MoveEvent()

function poisonSpiderCaveFloor.onStepIn(player, position, fromPosition)
    local floor1 = Tile(floorPos1):getItemById(9021)
    local floor2 = Tile(floorPos2):getItemById(9021)
    local floor3 = Tile(floorPos3):getItemById(9022)

    local floor4 = Tile(floorPos4):getItemById(9021)
    local floor5 = Tile(floorPos5):getItemById(9025)
    local floor6 = Tile(floorPos6):getItemById(9025)
    local floor7 = Tile(floorPos7):getItemById(9025)

    local floor8 = Tile(floorPos8):getItemById(9021)
    local floor9 = Tile(floorPos9):getItemById(9024)
    local floor10 = Tile(floorPos10):getItemById(9023)

    if player:isPlayer() and floor1 then
        Tile(pos1):relocateTo(relocatePos1)
        Tile(pos2):relocateTo(relocatePos2)

        doSendMagicEffect(floorPos1, CONST_ME_GROUNDSHAKER)
        doSendMagicEffect(floorPos2, CONST_ME_GROUNDSHAKER)
        doSendMagicEffect(floorPos3, CONST_ME_GROUNDSHAKER)
        doSendMagicEffect(floorPos4, CONST_ME_GROUNDSHAKER)
        doSendMagicEffect(floorPos5, CONST_ME_GROUNDSHAKER)
        doSendMagicEffect(floorPos6, CONST_ME_GROUNDSHAKER)
        doSendMagicEffect(floorPos7, CONST_ME_GROUNDSHAKER)
        doSendMagicEffect(floorPos8, CONST_ME_GROUNDSHAKER)
        doSendMagicEffect(floorPos9, CONST_ME_GROUNDSHAKER)
        doSendMagicEffect(floorPos10, CONST_ME_GROUNDSHAKER)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The ground collapsed behind you.")
        floor1:remove()
        floor2:remove()
        floor3:remove()
        floor4:remove()
        floor5:remove()
        floor6:remove()
        floor7:remove()
        floor8:remove()
        floor9:remove()
        floor10:remove()
    end
    return true
end

poisonSpiderCaveFloor:type("stepin")
poisonSpiderCaveFloor:aid(9907)
poisonSpiderCaveFloor:register()
