extends TakoState

var otherTako: Tako
var numMessages: int
var first: bool

onready var timer = $WaitTime

func enter(_msg := {}) -> void:
	DebugEvents.console_print(tako.logColor, owner.name, "Waiting tako")
	numMessages = _msg.numMessages
	first = _msg.first
	otherTako = _msg.otherTako as Tako
	
	timer.start()
	tako.set_physics_process(false)

func exit() -> void:
	tako.set_physics_process(true)
	timer.stop()

func _on_WaitTime_timeout() -> void:
	state_machine.transition_to("Idle")
