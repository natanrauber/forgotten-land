function onStepIn(cid, item, position, fromPosition)
    local t = {x = 31949, y = 32173, z = 10}
    local t2 = {x = 31946, y = 32173, z = 10}

    local wallpos1 = Position(31974, 32174, 10)
    local wallpos2 = Position(31962, 32174, 10)
    local wallpos3 = Position(31961, 32184, 10)
    local wallpos4 = Position(31953, 32187, 10)
    local wallpos5 = Position(31971, 32183, 10)
    local wallpos6 = Position(31952, 32173, 10)

    local relocatepos1 = Position(31975, 32174, 10)
    local relocatepos2 = Position(31963, 32174, 10)
    local relocatepos3 = Position(31960, 32184, 10)
    local relocatepos4 = Position(31954, 32187, 10)
    local relocatepos5 = Position(31970, 32183, 10)
    local relocatepos6 = Position(31953, 32173, 10)

    local leverpos1 = Position(31975, 32170, 10)
    local leverpos2 = Position(31961, 32168, 10)
    local leverpos3 = Position(31957, 32189, 10)
    local leverpos4 = Position(31968, 32179, 10)
    local leverpos5 = Position(31948, 32187, 10)
    local leverpos6 = Position(31976, 32179, 10)
    local lever1 = Tile(leverpos1):getItemById(10045)
    local lever2 = Tile(leverpos2):getItemById(10045)
    local lever3 = Tile(leverpos3):getItemById(10045)
    local lever4 = Tile(leverpos4):getItemById(10045)
    local lever5 = Tile(leverpos5):getItemById(10045)
    local lever6 = Tile(leverpos6):getItemById(10045)

    doTeleportThing(cid, t2)
    doSendMagicEffect(t, CONST_ME_TELEPORT)
    doSendMagicEffect(t2, CONST_ME_TELEPORT)
    doPlayerSendTextMessage(cid, 18, "You can't leave this room without defeat Kraknaknork!")

    if lever1 then
        Tile(wallpos1):relocateTo(relocatepos1)
        Game.createItem(8635, 1, wallpos1)
        lever1:transform(10044)
    end
    if lever2 then
        Tile(wallpos2):relocateTo(relocatepos2)
        Game.createItem(8633, 1, wallpos2)
        lever2:transform(10044)
    end
    if lever3 then
        Tile(wallpos3):relocateTo(relocatepos3)
        Game.createItem(8634, 1, wallpos3)
        lever3:transform(10044)
    end
    if lever4 then
        Tile(wallpos4):relocateTo(relocatepos4)
        Game.createItem(8636, 1, wallpos4)
        lever4:transform(10044)
    end
    if lever5 then
        Tile(wallpos5):relocateTo(relocatepos5)
        Game.createItem(8633, 1, wallpos5)
        lever5:transform(10044)
    end
    if lever6 then
        Tile(wallpos6):relocateTo(relocatepos6)
        Game.createItem(8635, 1, wallpos6)
        lever6:transform(10044)
    end

    return true
end
