-- The Rookie Guard Quest - Mission 10: Tomb Raiding

-- Sarcophagus (gather fleshy bone)

local sarcophagus = Action()

function sarcophagus.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission10)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	if missionState >= 1 then
		local sarcophagusState = player:getStorageValue(Storage.TheRookieGuard.Sarcophagus)
		if sarcophagusState == -1 then
			local reward = Game.createItem(13830, 1)
			player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"You have found " .. reward:getArticle() .. " " .. reward:getName() .. "."
			)
			player:setStorageValue(Storage.TheRookieGuard.Sarcophagus, 1)
			player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
		end
	end
	return true
end

sarcophagus:uid(40055)
sarcophagus:register()
