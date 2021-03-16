extends TakoState

func enter(_msg := {}) -> void:
	var takoList = get_tree().get_nodes_in_group("Available_tako") 
	# Erase itself from the list
	takoList.erase(tako)
	
	if takoList.size() == 0:
		state_machine.transition_to("Idle")
		return
	
	takoList.shuffle()
	var takoConv = takoList[0] as Tako
	var target = GlobalFunctions.randomCord(Vector2(100,100))
	
	#takoConv.emoteSprite.emote(takoConv.emoteSprite.EMOTES.circle,1)
	#tako.emoteSprite.emote(tako.emoteSprite.EMOTES.circle,1)
	
	var numMessages = randi() % 6 + 2
	DebugEvents.console_print(tako.logColor, owner.name, "Chat numMessages: " + String(numMessages))
	var message = {
			"target": target + Vector2(50,0),
			"return_to": "WaitConv",
			"arrivalT": 120,
			"decRad": 200,
			"timer": 10,
			"msg": {"otherTako": takoConv, "numMessages": numMessages, "first": false},
		}
	takoConv.stateMachine.transition_to("Move", message)
	
	var message2 = message.duplicate(true)
	message.target = target
	message.msg.otherTako = tako
	message.msg.first = true
	state_machine.transition_to("Move", message2)
	
