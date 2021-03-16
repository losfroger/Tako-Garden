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
	tako.emit_signal("arrivedConv")
	
	timer.start()
	otherTako.connect("arrivedConv", self, "_otherTako_arrived")

func exit() -> void:
	otherTako.disconnect("arrivedConv", self, "_otherTako_arrived")
	timer.stop()

func _otherTako_arrived():
	DebugEvents.console_print(tako.logColor, owner.name, "Other tako arrived")
	state_machine.transition_to("Conv", {"numMessages": numMessages, "first": first})
	otherTako.stateMachine.transition_to("Conv", {"numMessages": numMessages, "first": !first})


func _on_WaitTime_timeout() -> void:
	state_machine.transition_to("Idle")
