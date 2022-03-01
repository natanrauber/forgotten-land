-- The Rookie Guard Quest - Mission 06: Run Like a Wolf

-- War wolf den entrance hole
local wolfDenEntranceHole = MoveEvent()

function wolfDenEntranceHole.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission06)
	if missionState < 2 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no business down there.")
		player:teleportTo(fromPosition, true)
	elseif missionState == 2 then
		player:setStorageValue(Storage.TheRookieGuard.Mission06, 3)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found the wolf den.")
	end
	return true
end

wolfDenEntranceHole:uid(25024)
wolfDenEntranceHole:register()

-- Skinning knife (skinning dead war wolf)
local skinningKnife = Action()

function skinningKnife.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission06)
	if missionState == 3 and item2.uid == 40045 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You got the war wolf leather. Time to get out of here.")
		player:setStorageValue(Storage.TheRookieGuard.Mission06, 4)
		player:addExperience(50, true)
		player:addItemEx(Game.createItem(13879, 1), true, CONST_SLOT_WHEREEVER)
	end
	return true
end

skinningKnife:id(13828)
skinningKnife:register()

-- War wolf den exit ladder
local exitLadder = Action()

function exitLadder.onUse(player, item)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission06)
	if missionState == 4 then
		player:setStorageValue(Storage.TheRookieGuard.Mission06, 5)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You escaped from the wolves' den.")
	end
	player:teleportTo(Position(32087, 32104, 7))
	return true
end

exitLadder:uid(25027)
exitLadder:register()
