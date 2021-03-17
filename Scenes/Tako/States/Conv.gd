extends TakoState

onready var timer = $Timer
var emotes
var numMessages: int

func enter(_msg := {}) -> void:
	timer.stop()
	emotes = tako.emoteSprite
	numMessages = _msg.numMessages
	if _msg.first:
		var otherTako = _msg.otherTako as Tako
		if otherTako.stateMachine.state.name == "WaitConv":
			otherTako.stateMachine.transition_to("Conv",
				{"numMessages": numMessages, "first": false})
			emotes.emote(randi() % emotes.EMOTES.size() + 1, 1)
			timer.wait_time = 2
			timer.start()
		else:
			state_machine.transition_to("idle")
			return
	else:
		timer.wait_time = 1
		timer.start()

func exit() -> void:
	timer.stop()

func _on_Timer_timeout() -> void:
	timer.wait_time = 2
	numMessages -= 1
	if numMessages <= 0:
		state_machine.transition_to("Idle")
	else:
		emotes.emote(randi() % emotes.EMOTES.size() + 1, 1)
		timer.start()
