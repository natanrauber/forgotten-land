local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

local voices = {
	{text = "Evil little beasts..."},
	{text = "Nasty creepy crawlies!"},
	{text = "Hey! You over there, could you help me with a little quest? Just talk to me!"}
}
npcHandler:addModule(VoiceModule:new(voices))

local storeTalkCid = {}
local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) < 1 then
		player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 1)
		player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 1)
		npcHandler:setMessage(
			MESSAGE_GREET,
			"Hello |PLAYERNAME|, I saw you walking by and wondered if you could help me. Could you?"
		)
		storeTalkCid[cid] = 0
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh, |PLAYERNAME|, it's you again! Could you help me?")
		storeTalkCid[cid] = 0
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 2 then
		npcHandler:say(
			"Oh, what's wrong? As I said, simply go to my house south of here and go upstairs. Then come back and we'll continue our chat.",
			cid
		)
		return false
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 3 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			"Welcome back, |PLAYERNAME|! Ahh, you found my chest. Let me take a look at you. You put on that coat, {yes}?"
		)
		storeTalkCid[cid] = 1
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, "Hey, I want to give you a weapon for free! You should not refuse that!")
		storeTalkCid[cid] = 2
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 5 then
		npcHandler:say(
			"I need proof that you killed some cockroaches. Please bring me at least 3 of their legs. Good luck!",
			cid
		)
		return false
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 6 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back, have you killed those cockroaches?")
		storeTalkCid[cid] = 3
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 7 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			"Hello again, |PLAYERNAME|! It's great to see you. If you like, we can chat a little."
		)
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if isInArray({"yes", "right", "ok"}, msg) then
		if storeTalkCid[cid] == 0 then
			npcHandler:say(
				"Great, please go to my house, just a few steps south of here. Upstairs in my room, you'll find a chest. You can keep what you find inside of it! Come back after you got it and talk to me again.",
				cid
			)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 2)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 2)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif storeTalkCid[cid] == 1 then
			if player:getItemCount(2651) > 0 then
				local coatSlot = player:getSlotItem(CONST_SLOT_ARMOR)
				if coatSlot then
					npcHandler:say(
						"Ah, no need to say anything, I can see it suits you perfectly. Now we're getting to the fun part, let's get you armed! Are you ready for some {action}?",
						cid
					)
					player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 4)
					player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 3)
					storeTalkCid[cid] = 2
				else
					npcHandler:say(
						"Oh, you don't wear it properly yet. You need to put it on your armor slot. Is it a little clearer now?",
						cid
					)
					storeTalkCid[cid] = 1
				end
			else
				player:addItem(2651, 1)
				npcHandler:say(
					"Oh no, did you lose my coat? Well, lucky you, I have a spare one here. Don't lose it again! Now we're getting to the fun part, let's get you armed! Are you ready for some {action}?",
					cid
				)
				player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 4)
				player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 3)
				storeTalkCid[cid] = 2
			end
		elseif storeTalkCid[cid] == 2 then
			npcHandler:say(
				"I knew I could count on you. Here, take this good and sturdy weapon in your hand. Then go back to my house and down the ladder. I need you to kill some cockroaches down there. Remember to bring me at least 3 of their legs as proof. You can probably find a torch in one of my chests in the basement, in case you need. Good luck, and bye for now!",
				cid
			)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 4)
			player:setStorageValue(Storage.RookgaardTutorialIsland.TorchChest, -1)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 5)
			player:addItem(2382, 1)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif storeTalkCid[cid] == 3 then
			if (player:getItemCount(8710) >= 3) then
				player:removeItem(8710, 3)
				player:addExperience(100, true)
				player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 5)
				player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 7)
				npcHandler:say(
					"Good job! This is all I needed. Now I need to get back to my work. By the way... have you seen Zirella? She was looking for someone to help her. Maybe you could go and see her. She lives just to the east and down the mountain. So, thank you again and bye for now!",
					cid
				)
				npcHandler:releaseFocus(cid)
				npcHandler:resetNpc(cid)
			else
				npcHandler:say("I need proof. Please bring me at least 3 of their legs. Good luck!", cid)
				return false
			end
		end
	elseif msgcontains(msg, "action") then
		if storeTalkCid[cid] == 2 then
			npcHandler:say(
				"I knew I could count on you. Here, take this good and sturdy weapon in your hand. Then go back to my house and down the ladder. I need you to kill some cockroaches down there. Remember to bring me at least 3 of their legs as proof. You can probably find a torch in one of my chests in the basement, in case you need. Good luck, and bye for now!",
				cid
			)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 4)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 5)
			player:addItem(2382, 1)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	end
	return true
end

local function onReleaseFocus(cid)
	storeTalkCid[cid] = nil
end

npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care, |PLAYERNAME|!.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye traveller.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
