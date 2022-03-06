local stairPosition = Position(32088, 32148, 10)

local catacombTileClose = MoveEvent()

function catacombTileClose.onStepIn(cid, item, position, fromPosition)
    local stair = Tile(stairPosition):getItemById(7525)

    if stair then
        stair:transform(7520)
    end
    return true
end

catacombTileClose:type("stepin")
catacombTileClose:aid(9906)
catacombTileClose:register()
