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
	{text = "I wish someone could spare a minute and help me..."},
	{text = "This is too hard for an old woman like me."},
	{text = "Hello, young adventurer, you look strong enough to help me!"}
}
npcHandler:addModule(VoiceModule:new(voices))

-- greet
local storeTalkCid = {}
local function greetCallback(cid)
	local player = Player(cid)

	if -- mission not started
		player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh, heaven must have sent you! Could you please help me with a {quest}?")
		storeTalkCid[cid] = 0
	elseif -- mission started
		player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back, darling... so about that firewood, could you please {help} me?")
		storeTalkCid[cid] = 2
	elseif -- explain again
		player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 2 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			"Welcome back, darling... so about the {dead trees}, let me explain that a little more, {yes}?"
		)
		storeTalkCid[cid] = 3
	elseif -- explain again
		player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 3 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			"Welcome back, darling... so about the {branches}, let me explain that a little more, {yes}?"
		)
		storeTalkCid[cid] = 4
	elseif -- explain again
		player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 4 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			"Welcome back, darling... so about the {pushing}, let me explain that a little more, {yes}?"
		)
		storeTalkCid[cid] = 5
	elseif -- explain again
		player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 5 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			"Welcome back, darling... so about the {cart}, let me explain that a little more, {yes}?"
		)
		storeTalkCid[cid] = 6
	elseif -- explain again
		player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 6 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh, sweetheart, is there a problem with the quest? Should I explain it again?")
		storeTalkCid[cid] = 7
	elseif -- mission complete
		player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 7 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			"Right, thank you sweetheart! This will be enough to heat my oven. Oh, and you are probably waiting for your reward, {yes}?"
		)
		storeTalkCid[cid] = 8
	elseif -- finished
		player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 8 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			"Oh, welcome back, dear |PLAYERNAME|! Are you here for a little chat? Just choose a topic."
		)
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if isInArray({"yes", "quest", "ok"}, msg) then
		if -- accept mission
			storeTalkCid[cid] == 0 then
			npcHandler:say(
				"Thank you so much for your kindness. I'm an old woman and I desperately need firewood for my oven. Could you please help me?",
				cid
			)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 1)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 1)
			storeTalkCid[cid] = 2
		elseif -- understood mission
			storeTalkCid[cid] == 2 then
			npcHandler:say(
				"You're such a treasure. In the forest south of here, there are {dead trees} without any leaves. The first thing you have to do is search for one, {okay}?",
				cid
			)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 2)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 2)
			storeTalkCid[cid] = 3
		elseif -- understood mission
			storeTalkCid[cid] == 3 then
			npcHandler:say("Splendid, once you've found one, break a branch from it. Did you understand that so far?", cid)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 3)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 3)
			storeTalkCid[cid] = 4
		elseif -- understood mission
			storeTalkCid[cid] == 4 then
			npcHandler:say("Good... so after you broke a branch, please push it here and put on my cart. {Alright}?", cid)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 4)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 4)
			player:setStorageValue(Storage.RookgaardTutorialIsland.BranchState, os.time())
			storeTalkCid[cid] = 5
		elseif -- understood mission
			storeTalkCid[cid] == 5 then
			npcHandler:say(
				"Thank you darling! My cart is right beside me. It's a little complicated: I need some firewood, but it's very difficult for my slightly advanced age. Please go into the the forest southeast of here. You will find fine old rotten brown trees. Get a loose branch and drag it to my cart. Don't worry, you will see what I mean on the way. Thanks and {bye} for now!",
				cid
			)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 6)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 6)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif -- explain mission again
			storeTalkCid[cid] == 7 then
			npcHandler:say(
				"So, the quest was to go into the forest south of here and to find a dead tree. Break a dry branch from it and then drag it back to my cart. Thanks again for offering your help!",
				cid
			)
			storeTalkCid[cid] = nil
		elseif -- get reward
			storeTalkCid[cid] == 8 then
			npcHandler:say(
				"Oh, you deserve it. You really have earned some experience! Also, you may enter my little house now and take what's in that chest beside my bed. I'll stop bothering you now and let you make your way to the village. I saw a recruiter arriving there recently, you should talk to him if you want more quests. Good {bye} for now!",
				cid
			)
			player:addExperience(50, true)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaQuestLog, 8)
			player:setStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 8)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif -- mission not completed but needs no explanation
		msgcontains(msg, "no") then
		if storeTalkCid[cid] == 7 then
			npcHandler:say("Well then, I hope you find nice and dry branches for me! Good {bye}!", cid)
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
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye |PLAYERNAME|, may Uman bless you!.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye traveller, take care.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
