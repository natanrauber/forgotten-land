local doorPos = Position(32122, 32127, 11)
local relocatePos = Position(32123, 32127, 11)

local katanaQuestLever = Action()

function katanaQuestLever.onUse(player, item, fromPosition, target, toPosition)
    local doorLocked = Tile(doorPos):getItemById(5107)
    local doorClosed = Tile(doorPos):getItemById(5108)
    local doorOpen = Tile(doorPos):getItemById(5109)

    if item.itemid == 10044 and doorLocked then
        item:transform(10045)
        doorLocked:transform(5109)
    elseif item.itemid == 10045 and doorClosed then
        item:transform(10044)
        Tile(doorPos):relocateTo(relocatePos)
        doorClosed:transform(5107)
    elseif item.itemid == 10045 and doorOpen then
        item:transform(10044)
        Tile(doorPos):relocateTo(relocatePos)
        doorOpen:transform(5107)
    end
    return true
end

katanaQuestLever:aid(9995)
katanaQuestLever:register()
