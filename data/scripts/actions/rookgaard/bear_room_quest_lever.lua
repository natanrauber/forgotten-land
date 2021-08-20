local stonePosition = Position(32090, 32080, 11)
local relocatePosition = Position(32090, 32081, 11)

local bearRoomQuestLever = Action()

function bearRoomQuestLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid == 1945 then
        local stoneItem = Tile(stonePosition):getItemById(1304)
        if stoneItem then
            stoneItem:remove()
            item:transform(1946)
        end
    else
        Tile(stonePosition):relocateTo(relocatePosition)
        Game.createItem(1304, 1, stonePosition)
        item:transform(1945)
    end
    return true
end

bearRoomQuestLever:aid(9994)
bearRoomQuestLever:register()