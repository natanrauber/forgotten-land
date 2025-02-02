-- The Rookie Guard Quest - Mission 12: Into The Fortress

-- Treasure chest (gather final mission items)
local reward = {
	containerId = 1987,
	itemIds = {
		13927,
		13928,
		13923,
		13830
	}
}

local treasureChest = Action()

function treasureChest.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	if missionState >= 1 and missionState <= 13 then
		local chestState = player:getStorageValue(Storage.TheRookieGuard.AcademyChest)
		local chestTimer = player:getStorageValue(Storage.TheRookieGuard.AcademyChestTimer)
		if chestState == -1 or chestTimer - os.time() <= 0 then
			local container = Game.createItem(reward.containerId)
			for i = #reward.itemIds, 1, -1 do
				container:addItem(reward.itemIds[i], 1)
			end
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"You have found " .. container:getArticle() .. " " .. container:getName() .. "."
			)
			player:setStorageValue(Storage.TheRookieGuard.AcademyChest, 1)
			player:setStorageValue(Storage.TheRookieGuard.AcademyChestTimer, os.time() + 24 * 60 * 60)
			player:addItemEx(container, true, CONST_SLOT_WHEREEVER)
			player:setStorageValue(Storage.TheRookieGuard.Mission12, 2)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
		end
	end
	return true
end

treasureChest:uid(40056)
treasureChest:register()

-- Orc Fortress entrance tiles
local fortressEntrance = MoveEvent()

function fortressEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	local guardPos = Position(31918, 32135, 7)
	local toPos = Position(31922, 32137, 7)

	if not player then
		return true
	end

	local guard = Tile(guardPos):getItemById(13931)

	if guard then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The guard kicked you out.")
		player:teleportTo(toPos, true)
	elseif missionState == 3 then
		player:setStorageValue(Storage.TheRookieGuard.Mission12, 5)
	end
	return true
end

fortressEntrance:aid(50356)
fortressEntrance:register()

-- Rolling pin (Knock out guard)
local function orcRecovery(position)
	local tile = Tile(position)
	if tile then
		local item = tile:getItemById(13930)
		if item then
			item:transform(13931, 1)
		end
	end
end

local rollingPin = Action()

function rollingPin.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	if missionState >= 1 and missionState <= 13 and item2.itemid == 13931 and topos == Position(31918, 32135, 7) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You knock the orc guard. The fortress gates are unguarded!")
		if missionState < 3 then
			player:setStorageValue(Storage.TheRookieGuard.Mission12, 3)
			player:addExperience(50, true)
		end
		item2:transform(13930, 1)
		addEvent(orcRecovery, 60000, item2:getPosition())
	end
	return true
end

rollingPin:id(13928)
rollingPin:register()

-- Elite Orc Guard tiles
local fortressEntrance = MoveEvent()

function fortressEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	local guardPos = Position(31908, 32129, 7)
	local toPos = Position(31908, 32134, 7)

	if not player then
		return true
	end

	local guard = Tile(guardPos):getItemById(13931)

	if guard then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The guard kicked you out.")
		player:teleportTo(toPos, true)
	end
	return true
end

fortressEntrance:aid(50357)
fortressEntrance:register()

-- Fleshy bone (Distract elite orc guard)
local monstersList = {
	{name = "Running Elite Orc Guard", amount = 1},
	{name = "Wild Dog", amount = 5}
}
local monsters = {}

local function eliteOrcGuardRecovery(position)
	if monsters then
		for i = 1, #monsters do
			monsters[i]:getPosition():sendMagicEffect(CONST_ME_POFF)
			monsters[i]:remove()
		end
	end
	Game.createItem(13931, 1, position)
end

local fleshyBone = Action()

function fleshyBone.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	if missionState >= 5 and item2.itemid == 13931 and topos == Position(31908, 32129, 7) then
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"This should be enough distraction for you to sneak into the fortress! Hurry up!"
		)
		if missionState == 5 then
			player:setStorageValue(Storage.TheRookieGuard.Mission12, 6)
			player:addExperience(50, true)
		end
		local position = item2:getPosition()
		local spawnPosition = Position(position.x, position.y + 1, position.z)
		item2:remove()
		monsters = {}
		for i = 1, #monstersList do
			if i == 2 then
				spawnPosition.y = spawnPosition.y + 2
			end
			for j = 1, monstersList[i].amount do
				monsters[#monsters + 1] = Game.createMonster(monstersList[i].name, spawnPosition)
			end
		end
		position:sendMagicEffect(CONST_ME_TELEPORT)
		addEvent(eliteOrcGuardRecovery, 60000, position)
	end
	return true
end

fleshyBone:id(13830)
fleshyBone:allowFarUse(true)
fleshyBone:register()

-- Elite Orc Guard back tile
local fortressTrapdoor = MoveEvent()

function fortressTrapdoor.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	local toPos = Position(31908, 32128, 8)

	if not player then
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You're inside the orc fortress.")
	player:setStorageValue(Storage.TheRookieGuard.Mission12, 7)
	player:teleportTo(toPos, true)

	return true
end

fortressTrapdoor:aid(50358)
fortressTrapdoor:register()

-- Wasp poison flask (Poison cauldron)
local poisonFlask = Action()

function poisonFlask.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	if missionState == 7 and item2.actionid == 40012 then
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"You poisoned Kraknaknork's soup. This should weaken him immensely. Time to find his room."
		)
		player:setStorageValue(Storage.TheRookieGuard.Mission12, 8)
		player:removeItem(13923, 1)
		player:addExperience(50, true)
	end
	return true
end

poisonFlask:id(13923)
poisonFlask:register()

-- Tarantula trap (Slow furious orc berserker)
local taranturaTrap = Action()

function taranturaTrap.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	target = Tile(topos):getTopCreature()
	if missionState >= 8 and target:getName() == "Furious Orc Berserker" then
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"The berserker can't catch you anymore - but only for 20 seconds. You need to lure him away from the teleporter!"
		)
		if missionState == 8 then
			player:setStorageValue(Storage.TheRookieGuard.Mission12, 9)
		end
		local conditionSlow = Condition(CONDITION_PARALYZE)
		conditionSlow:setParameter(CONDITION_PARAM_TICKS, 20000)
		conditionSlow:setFormula(-0.3, 0, -0.45, 0)
		target:addCondition(conditionSlow)
	end
	return true
end

taranturaTrap:id(13927)
taranturaTrap:register()

-- Kraknaknork lair teleport
local bossLairTeleport = MoveEvent()

function bossLairTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	-- Skip if not was started or finished
	if missionState == -1 then
		return true
	end
	if missionState == 8 then
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"As long as the orc berserker is near that teleporter, you can't enter."
		)
		player:teleportTo(fromPosition, true)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if missionState >= 9 then
		local spectators = Game.getSpectators(position, false, false, 2, 2, 2, 2)
		for i = 1, #spectators do
			if not spectators[i]:isPlayer() and spectators[i]:getName() == "Furious Orc Berserker" then
				player:sendTextMessage(
					MESSAGE_EVENT_ADVANCE,
					"As long as the orc berserker is near that teleporter, you can't enter."
				)
				player:teleportTo(fromPosition, true)
				position:sendMagicEffect(CONST_ME_TELEPORT)
				fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end
		end
		if missionState == 9 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You're entering Kraknaknork's lair.")
			player:setStorageValue(Storage.TheRookieGuard.Mission12, 10)
		end
		local toPosition = Position(31908, 32152, 10)
		player:teleportTo(toPosition, false)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

bossLairTeleport:uid(40057)
bossLairTeleport:register()

-- Energy barriers
local energyBarriers = {
	[40058] = {
		position = {x = 31902, y = 32153, z = 10},
		teleportTo = {x = 31904, y = 32152, z = 10},
		message = "Kraknaknork maintains strong energy barriers. There is only one way to disable them."
	},
	[40059] = {
		position = {x = 31890, y = 32153, z = 10},
		teleportTo = {x = 31892, y = 32153, z = 10}
	},
	[40060] = {
		position = {x = 31889, y = 32163, z = 10},
		teleportTo = {x = 31887, y = 32163, z = 10}
	},
	[40061] = {
		position = {x = 31881, y = 32166, z = 10},
		teleportTo = {x = 31883, y = 32166, z = 10}
	},
	[40062] = {
		position = {x = 31899, y = 32162, z = 10},
		teleportTo = {x = 31970, y = 32183, z = 10}
	},
	[40063] = {
		position = {x = 31880, y = 32152, z = 10},
		teleportTo = {x = 31882, y = 32152, z = 10}
	}
}

local missionEnergyBarriers = MoveEvent()

function missionEnergyBarriers.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local energyBarrier = energyBarriers[item.uid]
	local teleportPosition = Position(energyBarrier.teleportTo)
	player:teleportTo(teleportPosition, false)
	position:sendMagicEffect(CONST_ME_PURPLEENERGY)
	teleportPosition:sendMagicEffect(CONST_ME_PURPLEENERGY)
	if energyBarrier.message then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, energyBarrier.message)
	end
	return true
end

for index, value in pairs(energyBarriers) do
	missionEnergyBarriers:uid(index)
end
missionEnergyBarriers:register()

-- Levers
local levers = {
	[40064] = {
		barrier = 40058,
		message = "The energy barrier to the south temporarily disappeared."
	},
	[40065] = {
		barrier = 40059
	},
	[40066] = {
		barrier = 40060
	},
	[40067] = {
		barrier = 40061
	},
	[40068] = {
		barrier = 40062
	},
	[40069] = {
		barrier = 40063,
		newState = 11
	}
}

local function energyBarrierRestore(barrierUID)
	local energyBarrier = Tile(energyBarriers[barrierUID].position):getItemById(13934)
	if not energyBarrier then
		energyBarrier = Game.createItem(13934, 1, energyBarriers[barrierUID].position)
		energyBarrier:setAttribute(ITEM_ATTRIBUTE_UNIQUEID, barrierUID)
	end
end

local missionLevers = Action()

function missionLevers.onUse(player, item, position, item2, toPosition)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	if missionState >= 10 then
		local lever = levers[item.uid]
		local energyBarrier = Tile(energyBarriers[lever.barrier].position):getItemById(13934)
		if energyBarrier then
			energyBarrier:getPosition():sendMagicEffect(CONST_ME_PURPLEENERGY)
			energyBarrier:remove()
			if lever.message then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, lever.message)
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "An energy barrier somewhere temporarily disappeared.")
			end
			if missionState == 10 and lever.newState then
				player:setStorageValue(Storage.TheRookieGuard.Mission12, lever.newState)
			end
			addEvent(energyBarrierRestore, 60000, lever.barrier)
		else
			player:say("<click>", TALKTYPE_MONSTER_SAY, false, player, position)
		end
	end
	return true
end

for index, value in pairs(levers) do
	missionLevers:uid(index)
end
missionLevers:register()

-- Kraknaknork room
local boss = {
	uid = nil,
	fight = nil,
	roomCenter = {x = 31865, y = 32150, z = 10}
}

local function finishBossFight(playerUid, bossUid)
	local player = Player(playerUid)
	-- Kick out the player
	if player then
		local roomExitPosition = Position(31980, 32173, 10)
		player:teleportTo(roomExitPosition, false)
		roomExitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"With his last energy, Kraknaknork pushes you out of his throne room. Hurry back and defeat him before he regains his power."
		)
		local health, maxHealth = player:getHealth(), player:getBaseMaxHealth()
		-- Heal the player if needed
		if health < maxHealth then
			player:addHealth((maxHealth - health), COMBAT_HEALING)
		end
	end
	local boss = Creature(bossUid)
	-- Despawn the boss
	if boss then
		boss:getPosition():sendMagicEffect(CONST_ME_POFF)
		boss:remove()
	end
end

-- Kraknaknork room enter teleport
local enterBossRoomTeleport = MoveEvent()

function enterBossRoomTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	-- Skip if not was started or finished
	if missionState == -1 then
		return true
	end
	if missionState >= 11 then
		local spectators = Game.getSpectators(Position(boss.roomCenter), false, true, 9, 9, 5, 5)
		-- Check if there is a player inside the room
		if #spectators > 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A player is already inside the boss room.")
			player:teleportTo(fromPosition, false)
			return true
		end
		-- Spawn the boss
		local bossCreature = Game.createMonster("Kraknaknork", Position(31860, 32149, 10))
		local bossDeath = CreatureEvent("KraknaknorkDeath")
		function bossDeath.onDeath(player, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
			stopEvent(boss.fight)
		end
		bossDeath:register()
		bossCreature:registerEvent("KraknaknorkDeath")
		boss.uid = bossCreature.uid
		-- Teleport the player to the room
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"You're entering Kraknaknork's throne room. You have 5 minutes to kill him!"
		)
		player:setStorageValue(Storage.TheRookieGuard.Mission12, 12)
		local roomPosition = Position(31873, 32152, 10)
		player:teleportTo(roomPosition, false)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		roomPosition:sendMagicEffect(CONST_ME_TELEPORT)
		-- Start boss fight timer
		boss.fight = addEvent(finishBossFight, 5 * 60 * 1000, player.uid, bossCreature.uid)
	end
	return true
end

enterBossRoomTeleport:uid(40070)
enterBossRoomTeleport:register()

-- Kraknaknork room exit teleport
local exitBossRoomTeleport = MoveEvent()

function exitBossRoomTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	local spectators = Game.getSpectators(Position(boss.roomCenter), false, false, 9, 9, 5, 5)
	-- Check the boss do not exist
	if #spectators > 0 then
		for i = 1, #spectators do
			if not spectators[i]:isPlayer() and spectators[i]:getName() == "Kraknaknork" then
				-- Cancel boss fight timer
				stopEvent(boss.fight)
				-- Teleport the player
				local roomExitPosition = Position(31878, 32152, 10)
				player:teleportTo(roomExitPosition, false)
				position:sendMagicEffect(CONST_ME_TELEPORT)
				roomExitPosition:sendMagicEffect(CONST_ME_TELEPORT)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You backed out of the fight. You may try again at any time.")
				-- Despawn the boss
				local boss = Creature(boss.uid)
				if boss then
					boss:getPosition():sendMagicEffect(CONST_ME_POFF)
					boss:remove()
				end
				return true
			end
		end
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already killed Kraknaknork, just proceed to the next teleport.")
	player:teleportTo(fromPosition, false)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return false
end

exitBossRoomTeleport:uid(40071)
exitBossRoomTeleport:register()

-- Kraknaknork treasure room enter teleport
local enterTreasureRoomTeleport = MoveEvent()

function enterTreasureRoomTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	if missionState == 12 then
		local spectators = Game.getSpectators(Position(boss.roomCenter), false, false, 9, 9, 5, 5)
		-- Check the boss do not exist
		if #spectators > 0 then
			for i = 1, #spectators do
				if not spectators[i]:isPlayer() and spectators[i]:getName() == "Kraknaknork" then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You may not use this teleporter yet.")
					player:teleportTo(fromPosition, false)
					position:sendMagicEffect(CONST_ME_TELEPORT)
					fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
					return false
				end
			end
		end
		-- Teleport the player to the treasure room
		player:setStorageValue(Storage.TheRookieGuard.Mission12, 13)
		local treasureRoomPosition = Position(31886, 32154, 11)
		player:teleportTo(treasureRoomPosition, false)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		treasureRoomPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

enterTreasureRoomTeleport:uid(40072)
enterTreasureRoomTeleport:register()

-- Boss treasure chests (Rewards: small ruby and 2 platinum coins)
local CHEST_ID = {
	LEFT = 1,
	RIGHT = 2
}

local chests = {
	[40073] = {
		id = CHEST_ID.LEFT,
		item = {
			id = 2147,
			amount = 1
		}
	},
	[40074] = {
		id = CHEST_ID.RIGHT,
		item = {
			id = 2152,
			amount = 2
		}
	}
}

local bossChests = Action()

function bossChests.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	if missionState == 13 then
		local chest = chests[item.uid]
		local chestsState = player:getStorageValue(Storage.TheRookieGuard.KraknaknorkChests)
		local hasUsedChest = testFlag(chestsState, chest.id)
		if not hasUsedChest then
			local reward = Game.createItem(chest.item.id, chest.item.amount)
			if reward:getCount() == 1 then
				player:sendTextMessage(
					MESSAGE_EVENT_ADVANCE,
					"You have found " .. reward:getArticle() .. " " .. reward:getName() .. "."
				)
			elseif reward:getCount() > 1 then
				player:sendTextMessage(
					MESSAGE_EVENT_ADVANCE,
					"You have found " .. reward:getCount() .. " " .. reward:getPluralName() .. "."
				)
			end
			player:setStorageValue(Storage.TheRookieGuard.KraknaknorkChests, chestsState + chest.id)
			player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
		end
	end
	return true
end

bossChests:uid(40073, 40074)
bossChests:register()

-- Kraknaknork treasure room exit teleport
local exitTreasureRoomTeleport = MoveEvent()

function exitTreasureRoomTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission12)
	if missionState == 13 then
		local health, maxHealth = player:getHealth(), player:getBaseMaxHealth()
		-- Heal the player if needed
		if health < maxHealth then
			player:addHealth((maxHealth - health), COMBAT_HEALING)
		end
		-- Teleport the player to the orcland exit
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"With Kraknaknork's final source of energy, you escape the fortress. Time to return to Vascalir."
		)
		player:setStorageValue(Storage.TheRookieGuard.Mission12, 14)
		local exitPosition = Position(31909, 32151, 9)
		player:teleportTo(exitPosition, false)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

exitTreasureRoomTeleport:uid(40075)
exitTreasureRoomTeleport:register()

-- Orc fortress and Kraknaknork lair chests
local CHEST_ID = {
	FORTRESS_TREASURE_CHEST = 1,
	FORTRESS_TRUNK = 2,
	LAIR_TREASURE_CHEST = 4
}

local chests = {
	[40079] = {
		id = CHEST_ID.FORTRESS_TREASURE_CHEST,
		item = {
			id = 2695,
			amount = 30
		}
	},
	[40080] = {
		id = CHEST_ID.FORTRESS_TRUNK,
		item = {
			id = 8704,
			amount = 2
		}
	},
	[40081] = {
		id = CHEST_ID.LAIR_TREASURE_CHEST,
		item = {
			id = 8704,
			amount = 1
		}
	}
}

local orcFortressChests = Action()

function orcFortressChests.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission10)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	local chest = chests[item.uid]
	local chestsState = player:getStorageValue(Storage.TheRookieGuard.OrcFortressChests)
	local hasOpenedChest = testFlag(chestsState, chest.id)
	if not hasOpenedChest then
		local reward = Game.createItem(chest.item.id, chest.item.amount)
		if reward:getCount() == 1 then
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"You have found " .. reward:getArticle() .. " " .. reward:getName() .. "."
			)
		elseif reward:getCount() > 1 then
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"You have found " .. reward:getCount() .. " " .. reward:getPluralName() .. "."
			)
		end
		player:setStorageValue(Storage.TheRookieGuard.OrcFortressChests, chestsState + chest.id)
		player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
	end
	return true
end

orcFortressChests:uid(40079, 40080, 40081)
orcFortressChests:register()
