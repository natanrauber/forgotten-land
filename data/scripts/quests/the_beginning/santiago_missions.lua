--
-- COAT CHEST
--
local santiagoCoatChest = Action()

function santiagoCoatChest.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage)

	if -- mission not started
		missionState < 2 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is locked.")
	elseif -- mission started
		missionState == 2 then
		local reward = Game.createItem(2651, 1)
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"You have found " .. reward:getArticle() .. " " .. reward:getName() .. "."
		)
		player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 3)
		player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
	elseif -- mission complete
		missionState > 2 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
	end

	return true
end

santiagoCoatChest:uid(60101)
santiagoCoatChest:register()

--
-- TORCH QUEST
--
local santiagoTorchChest = Action()

function santiagoTorchChest.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage)
	local torchChestState = player:getStorageValue(Storage.RookgaardTutorialIsland.TorchChest)

	if -- mission not started
		missionState < 5 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is locked.")
	elseif -- mission started
		missionState == 5 and torchChestState == -1 then
		local reward = Game.createItem(2050, 1)
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"You have found " .. reward:getArticle() .. " " .. reward:getName() .. "."
		)
		player:setStorageValue(Storage.RookgaardTutorialIsland.TorchChest, 1)
		player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
	elseif -- mission complete
		missionState > 5 or torchChestState == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
	end

	return true
end

santiagoTorchChest:uid(60102)
santiagoTorchChest:register()

--
-- SEWER GRATE
--
local santiagoSewerGrate = Action()

function santiagoSewerGrate.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage)
	local torchChestState = player:getStorageValue(Storage.RookgaardTutorialIsland.TorchChest)
	local litTorch1 = player:getItemCount(2051)
	local litTorch2 = player:getItemCount(2053)
	local litTorch3 = player:getItemCount(2055)

	if -- mission not started
		missionState < 5 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is locked.")
	elseif -- mission started but doesnt have torch
		(missionState == 5 or missionState == 6) and litTorch1 < 1 and litTorch2 < 1 and litTorch3 < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is dark down there, you should find a torch before you go down.")
	elseif -- mission started and have torch
		(missionState == 5 or missionState == 6) and (litTorch1 >= 1 or litTorch2 >= 1 or litTorch3 >= 1) then
		player:teleportTo({x = 31968, y = 32275, z = 9})
		player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 6)
	elseif -- mission complete
		missionState > 6 then
		player:teleportTo({x = 31968, y = 32275, z = 9})
	end

	return true
end

santiagoSewerGrate:uid(60103)
santiagoSewerGrate:register()
