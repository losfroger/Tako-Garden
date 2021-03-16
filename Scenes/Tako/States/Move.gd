# State that makes the tako go to a random place on screen
extends TakoState

export var margin: Vector2
export var arrival_tolerance = 80
export var deceleration_radius = 180

var return_to: String = ""
var msg_next := {}

onready var target := GSAIAgentLocation.new()
onready var avoid: GSAIAvoidCollisions
onready var seek: GSAIArrive

onready var wander_blend: GSAIBlend

onready var timer = $Timer

# _msg can have `target` which dictates target position of movement
# and `return_to` for the state to which it'll return to, once it arrives
func enter(_msg := {}) -> void:
	avoid = GSAIAvoidCollisions.new(tako.agent, tako.proximity_takos)
	seek = GSAIArrive.new(tako.agent, target)
	wander_blend = GSAIBlend.new(tako.agent)

	if _msg.has_all(["arrivalT", "decRad"]):
		seek.arrival_tolerance = _msg.arrivalT
		seek.deceleration_radius = _msg.decRad
	else:
		seek.arrival_tolerance = arrival_tolerance
		seek.deceleration_radius = deceleration_radius
	
	if _msg.has_all(["target", "return_to"]):
		DebugEvents.console_print(tako.logColor, owner.name, "Has target")
		target.position.x = _msg.target.x
		target.position.y = _msg.target.y
		return_to = _msg.return_to
	else:
		DebugEvents.console_print(tako.logColor, owner.name, "Wander")
		var randomCoord = GlobalFunctions.randomCord(margin)
		target.position.x = randomCoord.x
		target.position.y = randomCoord.y
	
	if _msg.has("msg"):
		msg_next = _msg.msg
	
	if _msg.has("timer"):
		timer.wait_time = _msg.timer
		timer.start()

	wander_blend.add(seek, 1)
	wander_blend.add(avoid, 0.6)
	seek.connect("arrived", self, "_on_arrived")


func exit() -> void:
	return_to = ""
	msg_next = {}
	timer.stop()


func physics_update(delta: float) -> void:
	wander_blend.calculate_steering(tako._acceleration)
	tako.agent._apply_steering(tako._acceleration, delta)


func _on_arrived():
	if return_to.empty():
		DebugEvents.console_print(tako.logColor, owner.name, "Arrived to target")
		state_machine.transition_to("Idle")
	else:
		DebugEvents.console_print(tako.logColor, owner.name, "Arrived to custom target")
		state_machine.transition_to(return_to, msg_next)


func _on_timer_end() -> void:
	state_machine.transition_to("Idle")
