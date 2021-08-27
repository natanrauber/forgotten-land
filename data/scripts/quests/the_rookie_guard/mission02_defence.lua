-- The Rookie Guard Quest - Mission 02: Defence!

local CATAPULT_ID = {
	GATE_1 = 1,
	ACADEMY_1 = 2,
	ACADEMY_2 = 4,
	GATE_2 = 8
}

-- Stone pile (gather heavy stone)
local stonePile = Action()

function stonePile.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission02)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	if missionState <= 3 then
		if missionState == 1 then
			player:setStorageValue(Storage.TheRookieGuard.Mission02, 2)
		end
		-- Gather delay
		if player:getStorageValue(Storage.TheRookieGuard.StonePileTimer) - os.time() <= 0 then
			player:setStorageValue(Storage.TheRookieGuard.StonePileTimer, os.time() + 1 * 60)
			player:addItemEx(Game.createItem(13866, 1), true, CONST_SLOT_WHEREEVER)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait a while before you can pick up a new stone.")
		end
	end
	return true
end

stonePile:aid(40005)
stonePile:register()

local catapults = {
	[40006] = CATAPULT_ID.GATE_1,
	[40007] = CATAPULT_ID.ACADEMY_1,
	[40008] = CATAPULT_ID.ACADEMY_2,
	[40009] = CATAPULT_ID.GATE_2
}

-- Heavy stone (load stone on catapult)

local heavyStone = Action()

function heavyStone.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission02)
	if missionState >= 2 and missionState <= 3 and catapults[item2.actionid] then
		local catapultsState = player:getStorageValue(Storage.TheRookieGuard.Catapults)
		local hasUsedCatapult = testFlag(catapultsState, catapults[item2.actionid])
		if not hasUsedCatapult then
			if missionState == 2 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You load the first heavy stone on the catapult.")
			elseif missionState == 3 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You loaded the last stone on the catapults.")
			end
			player:setStorageValue(Storage.TheRookieGuard.Mission02, missionState + 1)
			player:setStorageValue(Storage.TheRookieGuard.Catapults, catapultsState + catapults[item2.actionid])
			player:addExperience(25, true)
			player:removeItem(13866, 1)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already loaded a stone on this catapult.")
		end
	end
	return true
end

heavyStone:id(13866)
heavyStone:register()
