local itemPos = Position(31967, 32262, 8)

local santiagoSnakeHead = Action()

function santiagoSnakeHead.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local itemOff = Tile(itemPos):getItemById(5058)
    local itemOn = Tile(itemPos):getItemById(5057)

    if (item.itemid == 1945) then
        item:transform(1946)
        itemOff:transform(5057)
    elseif (item.itemid == 1946) then
        item:transform(1945)
        itemOn:transform(5058)
    end

    return true
end

santiagoSnakeHead:aid(9987)
santiagoSnakeHead:register()
