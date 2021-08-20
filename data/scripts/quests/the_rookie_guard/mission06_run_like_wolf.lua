-- The Rookie Guard Quest - Mission 06: Run Like a Wolf

-- Skinning knife (skinning dead war wolf)

local skinningKnife = Action()

function skinningKnife.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission06)
	if missionState == 2 and item2.uid == 40045 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You got the war wolf leather. Time to get out of here.")
		player:setStorageValue(Storage.TheRookieGuard.Mission06, 3)
		player:addExperience(50, true)
		player:addItemEx(Game.createItem(13879, 1), true, CONST_SLOT_WHEREEVER)
	end
	return true
end

skinningKnife:id(13828)
skinningKnife:register()
