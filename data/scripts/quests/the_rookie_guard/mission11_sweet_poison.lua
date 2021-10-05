-- The Rookie Guard Quest - Mission 11: Sweet Poison

-- Wasps' lair tiles
local waspsLairTile = MoveEvent()

function waspsLairTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission11)
	if missionState == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You've found the wasp lair.")
		player:setStorageValue(Storage.TheRookieGuard.Mission11, 2)
	end
	return true
end

waspsLairTile:aid(50353)
waspsLairTile:register()

-- Special flask (gather poison on wasp corpse)
local specialFlask = Action()

function specialFlask.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission11)
	if missionState == 2 and item2.itemid == 5989 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You carefully gather some of the wasp poison.")
		player:setStorageValue(Storage.TheRookieGuard.Mission11, 3)
		player:removeItem(13924, 1)
		player:addItemEx(Game.createItem(13923, 1), true, CONST_SLOT_WHEREEVER)
	end
	return true
end

specialFlask:id(13924)
specialFlask:register()
