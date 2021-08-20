local stairPosition = Position(32143, 32169, 10)
local relocatePosition = Position(32143, 32167, 11)

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
