-- The Rookie Guard Quest - Mission 05: Web of Terror

-- Spider lair hole

local spiderLairHole = MoveEvent()

function spiderLairHole.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission05)
	if missionState == -1 or missionState >= 3 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no business down there.")
		player:teleportTo(fromPosition, true)
	end
	return true
end

spiderLairHole:uid(25022)
spiderLairHole:register()

-- Greasy stones

local greasyStone = Action()

function greasyStone.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission05)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	if missionState <= 2 or missionState == 4 then
		local condition = Condition(CONDITION_INVISIBLE)
		condition:setParameter(CONDITION_PARAM_TICKS, 60000)
		player:addCondition(condition)
		-- Check delayed notifications (message/arrow)
		if not isTutorialNotificationDelayed(player) then
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"You rub the strange grease on your body. The spider queen will not be able to smell you for a while. Hurry!"
			)
		-- Position({x = 32018, y = 32098, z = 11}):sendMagicEffect(CONST_ME_TUTORIALARROW)
		end
		player:setStorageValue(Storage.TheRookieGuard.Mission05, 2)
		player:setStorageValue(Storage.TheRookieGuard.GreaseTime, os.time() + 60)
	else
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"You already retrieved some of the spider queen's web. No need to go back down there."
		)
	end
	return true
end

greasyStone:id(13868)
greasyStone:register()

-- Spider queen chamber hole

local spiderQueenChamberHole = MoveEvent()

function spiderQueenChamberHole.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission05)
	local greaseTime = player:getStorageValue(Storage.TheRookieGuard.GreaseTime)
	if missionState == 1 or (missionState == 2 and greaseTime < os.time()) then
		-- Check delayed notifications (message/arrow)
		if not isTutorialNotificationDelayed(player) then
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"Don't enter the lair without a protective grease. Use one of the stones to the north to become invisible to her."
			)
		-- Position({x = 32014, y = 32096, z = 11}):sendMagicEffect(CONST_ME_TUTORIALARROW)
		end
		player:teleportTo(fromPosition, true)
	elseif missionState == 3 then
		-- Check delayed notifications (message/arrow)
		if not isTutorialNotificationDelayed(player) then
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"You already have the spider queen's web. You should go back to Vascalir and not take any further risks."
			)
		end
		player:teleportTo(fromPosition, true)
	end
	return true
end

spiderQueenChamberHole:uid(25023)
spiderQueenChamberHole:register()

-- Spider webs

local spiderWeb = Action()

function spiderWeb.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission05)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	if missionState == 2 or missionState == 4 then
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"You retrieved some of the spider queen's web. Hurry back before she can smell you again!"
		)
		player:setStorageValue(Storage.TheRookieGuard.Mission05, 3)
	end
	return true
end

spiderWeb:aid(40010)
spiderWeb:register()
