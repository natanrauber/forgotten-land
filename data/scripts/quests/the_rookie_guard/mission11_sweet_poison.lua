-- The Rookie Guard Quest - Mission 11: Sweet Poison

-- Special flask (gather poison on wasp corpse)

local specialFlask = Action()

function specialFlask.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission11)
	if missionState == 2 and item2.itemid == 5989 then
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"You carefully gather some of the wasp poison. Bring it back to Vascalir."
		)
		player:setStorageValue(Storage.TheRookieGuard.Mission11, 3)
		player:removeItem(13924, 1)
		player:addItemEx(Game.createItem(13923, 1), true, CONST_SLOT_WHEREEVER)
	end
	return true
end

specialFlask:id(13924)
specialFlask:register()
