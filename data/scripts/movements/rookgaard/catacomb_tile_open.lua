local stairPosition = Position(32088, 32148, 10)
local relocatePosition = Position(32088, 32146, 11)

local catacombTileOpen = MoveEvent()

function catacombTileOpen.onStepIn(cid, item, position, fromPosition)
    local stair = Tile(stairPosition):getItemById(7520)

    if stair then
        Tile(stairPosition):relocateTo(relocatePosition)
        stair:transform(7525)
    end
    return true
end

catacombTileOpen:type("stepin")
catacombTileOpen:aid(9905)
catacombTileOpen:register()
