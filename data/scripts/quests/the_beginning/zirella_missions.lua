--
-- GET BRANCH ON DEAD TREE
--
local zirellaDeadTree = Action()

function zirellaDeadTree.onUse(player, item, frompos, item2, topos)
    local missionState = player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage)
    local branchState = player:getStorageValue(Storage.RookgaardTutorialIsland.BranchState)

    if -- mission started and can get branch
        missionState == 6 and branchState < os.time() then
        local branch = Game.createItem(8582, 1)
        player:sendTextMessage(
            MESSAGE_EVENT_ADVANCE,
            "You have found " .. branch:getArticle() .. " " .. branch:getName() .. "."
        )
        player:setStorageValue(Storage.RookgaardTutorialIsland.BranchState, os.time() + 2 * 60)
        player:addItemEx(branch, true, CONST_SLOT_WHEREEVER)
    elseif -- mission started but branch on cooldown
        missionState == 6 and branchState > os.time() then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You didn't find anything here now.")
    end

    return true
end

zirellaDeadTree:id(8583)
zirellaDeadTree:register()

--
-- USE BRANCH ON CART
--
local zirellaBranch = Action()

function zirellaBranch.onUse(player, item, frompos, item2, topos)
    local missionState = player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage)
    if -- mission started
        missionState == 6 and item2.itemid == 8581 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You loaded the cart.")
        player:addExperience(25, true)
        item:remove()
        player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 7)
    end
    return true
end

zirellaBranch:id(8582)
zirellaBranch:register()

--
-- SHOVEL CHEST
--
local zirellaShovelChest = Action()

function zirellaShovelChest.onUse(player, item, frompos, item2, topos)
    local missionState = player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage)

    if -- mission not started
        missionState < 8 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is locked.")
    elseif -- mission started
        missionState == 8 then
        local reward = Game.createItem(2554, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a shovel. You can use it on stonepiles to dig.")
        player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 9)
        player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
    elseif -- mission complete
        missionState > 8 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
    end

    return true
end

zirellaShovelChest:uid(60104)
zirellaShovelChest:register()

--
-- ROPE CHEST
--
local zirellaRopeChest = Action()

function zirellaRopeChest.onUse(player, item, frompos, item2, topos)
    local missionState = player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage)

    if -- mission not started
        missionState < 9 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is locked.")
    elseif -- mission started
        missionState == 9 then
        local reward = Game.createItem(2120, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a rope. You can use it on ropespots to go up.")
        player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 10)
        player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
    elseif -- mission complete
        missionState > 9 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
    end

    return true
end

zirellaRopeChest:uid(60105)
zirellaRopeChest:register()
