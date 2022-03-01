-- The Rookie Guard Quest - Mission 07: Attack!

-- War wolf den entrance hole
local libraryEntranceHole = MoveEvent()

function libraryEntranceHole.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission07)
	if missionState < 1 or missionState == 4 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no business down there.")
		player:teleportTo(fromPosition, true)
	elseif missionState == 1 then
		player:setStorageValue(Storage.TheRookieGuard.Mission07, 2)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You entered the library.")
	end
	return true
end

libraryEntranceHole:uid(25025)
libraryEntranceHole:register()

-- Cough inside library vault
local libraryVaultSteps = MoveEvent()

function libraryVaultSteps.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission07)
	-- Skip if not was started or finished
	if missionState == -1 or missionState == 2 then
		return true
	end
	if math.random(100) <= 20 then
		player:say("<cough>", TALKTYPE_MONSTER_SAY, false, player, position)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		player:addHealth(-1, COMBAT_PHYSICALDAMAGE)
		local health, maxHealth = player:getHealth(), player:getMaxHealth()
		local coughTolerance = (health / maxHealth) * 100
		if health <= (maxHealth / 3) or math.random(100) <= (100 - coughTolerance) then
			player:teleportTo({x = 32089, y = 32152, z = 9})
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"You're coughing so badly that you had to return upstairs. Take a few deep breaths and try again."
			)
			player:addHealth((maxHealth - health), COMBAT_HEALING)
		end
	end
	return true
end

libraryVaultSteps:aid(50339)
libraryVaultSteps:register()

-- Fire fields (walk back on big fire fields)
local fireFields = MoveEvent()

function fireFields.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if item.itemid == 13882 then
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"This fire is much too hot to walk through it. You should look for another way."
		)
		player:teleportTo(fromPosition, true)
	end
	return true
end

fireFields:aid(40011)
fireFields:register()

-- Treasure chest (gather orc language book)
local treasureChest = Action()

function treasureChest.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission07)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	if missionState >= 2 then
		local libraryChestState = player:getStorageValue(Storage.TheRookieGuard.LibraryChest)
		if libraryChestState == -1 then
			local reward = Game.createItem(13831, 1)
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"You have found " .. reward:getArticle() .. " " .. reward:getName() .. "."
			)
			player:setStorageValue(Storage.TheRookieGuard.LibraryChest, 1)
			player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
			player:setStorageValue(Storage.TheRookieGuard.Mission07, 3)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
		end
	end
	return true
end

treasureChest:uid(40047)
treasureChest:register()
