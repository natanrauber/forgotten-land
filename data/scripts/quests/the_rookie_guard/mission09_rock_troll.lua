-- The Rookie Guard Quest - Mission 09: Rock 'n Troll

-- Troll caves dug tunnel hole
local tunnelHole = MoveEvent()

function tunnelHole.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission09)
	if missionState == -1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no business down there.")
		player:teleportTo(fromPosition, true)
	elseif missionState == 1 then
		player:setStorageValue(Storage.TheRookieGuard.Mission09, 2)
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"Find a pick and use it on the 5 beams to weaken the structure and make the tunnel collapse."
		)
	elseif missionState >= 7 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The cave has collapsed. It's not safe to go down there anymore.")
		player:teleportTo(fromPosition, true)
	end
	return true
end

tunnelHole:uid(25028)
tunnelHole:register()

-- Trunk chests (gather leather legs and pick)
local CHEST_ID = {
	LEATHER_LEGS = 1,
	PICK = 2
}

local chests = {
	[40048] = {
		id = CHEST_ID.LEATHER_LEGS,
		itemId = 2649
	},
	[40049] = {
		id = CHEST_ID.PICK,
		itemId = 2553
	}
}

local trunkChest = Action()

function trunkChest.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission09)
	-- Skip if not was started
	if missionState == -1 then
		return true
	elseif missionState >= 2 then
		local chest = chests[item.uid]
		local chestsState = player:getStorageValue(Storage.TheRookieGuard.TrollChests)
		local hasOpenedChest = testFlag(chestsState, chest.id)
		if not hasOpenedChest then
			local reward = Game.createItem(chest.itemId, 1)
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"You have found " .. reward:getArticle() .. " " .. reward:getName() .. "."
			)
			player:setStorageValue(Storage.TheRookieGuard.TrollChests, chestsState + chest.id)
			player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
		end
	end
	return true
end

trunkChest:uid(40048, 40049)
trunkChest:register()

-- Pick (use pick on pillars)
local PILLAR_ID = {
	BOTOM_RIGHT = 1,
	BOTTOM_LEFT = 2,
	TOP_LEFT = 4,
	TOP_CENTER = 8,
	TOP_RIGHT = 16
}

local tunnelPillars = {
	[40050] = PILLAR_ID.BOTOM_RIGHT,
	[40051] = PILLAR_ID.BOTTOM_LEFT,
	[40052] = PILLAR_ID.TOP_LEFT,
	[40053] = PILLAR_ID.TOP_CENTER,
	[40054] = PILLAR_ID.TOP_RIGHT
}

-- /data/scripts/lib/register_actions.lua (onUsePick)
function onUsePickAtTunnelPillar(player, item, fromPosition, item2, toPosition)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission09)
	local pillarId = tunnelPillars[item2.uid]
	if missionState >= 2 and missionState <= 7 and pillarId then
		local pillarsState = player:getStorageValue(Storage.TheRookieGuard.TunnelPillars)
		local hasDamagedPillar = testFlag(pillarsState, pillarId)
		if not hasDamagedPillar then
			local newMissionState = missionState + 1
			if table.find({3, 4, 5, 6}, newMissionState) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "That should weaken the beam enough to make it collapse soon.")
			elseif newMissionState == 7 then
				player:sendTextMessage(
					MESSAGE_EVENT_ADVANCE,
					"This was the last beam. Now, get out of here before the cave collapses!"
				)
				player:addExperience(100, true)
			end
			player:say("<crack>", TALKTYPE_MONSTER_SAY, false, player, toPosition)
			toPosition:sendMagicEffect(CONST_ME_HITAREA)
			player:setStorageValue(Storage.TheRookieGuard.Mission09, newMissionState)
			player:setStorageValue(Storage.TheRookieGuard.TunnelPillars, pillarsState + pillarId)
		else
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"You've already weakened this beam. Better leave it alone now so it won't collapse before you are out of here."
			)
		end
	end
	return true
end

-- exit ladder
local exitLadder = Action()

function exitLadder.onUse(player, item)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission09)
	-- Skip if not was started
	if missionState == 7 then
		player:setStorageValue(Storage.TheRookieGuard.Mission09, missionState + 1)
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"You've already weakened this beam. Better leave it alone now so it won't collapse before you are out of here."
		)
	end
	player:teleportTo(Position(32004, 32115, 9))
	return true
end

exitLadder:uid(40076)
exitLadder:register()
