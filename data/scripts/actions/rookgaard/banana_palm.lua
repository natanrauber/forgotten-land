local bananaPalm = Action()

function bananaPalm.onUse(player)
	if player:getStorageValue(Storage.QuestChests.BananaPalm) < os.time() then
		local chance = math.random(100)
		if chance >= 30 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a banana.")
			player:addItem(2676, 1)
		end
		player:setStorageValue(Storage.QuestChests.BananaPalm, os.time() + 3600)
	end
	return true
end

bananaPalm:id(2725)
bananaPalm:register()
