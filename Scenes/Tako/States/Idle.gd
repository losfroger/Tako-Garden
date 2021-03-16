# This state will decide randomly to get another state
extends TakoState

onready var timer = $Timer

enum STATES {
	WANDER = 0,
	IDLE = 1,
	CONV = 2,
}

var probStates = [
	{"item": STATES.WANDER, "weight": 2.0},
	{"item": STATES.IDLE, "weight": 2.0},
	{"item": STATES.CONV, "weight": 0.1},
	]

onready var avoid: GSAIAvoidCollisions

var probClass: WeightedRandom

func _ready() -> void:
	probClass = WeightedRandom.new(probStates)


func enter(_msg := {}) -> void:
	tako.add_to_group("Available_tako")
	avoid = GSAIAvoidCollisions.new(tako.agent, tako.proximity_takos)
	DebugEvents.console_print(tako.logColor, owner.name, "Idle")

	timer.wait_time = rand_range(1, 8)
	timer.start()


func physics_update(delta: float) -> void:
	avoid.calculate_steering(tako._acceleration)
	tako.agent._apply_steering(tako._acceleration, delta)

func exit() -> void:
	tako.remove_from_group("Available_tako")
	timer.stop()


func _on_timer_end() -> void:
	var random_state = probClass.random_pick()
	match random_state:
		STATES.WANDER:
			state_machine.transition_to("Move")
		STATES.IDLE:
			DebugEvents.console_print(tako.logColor, owner.name, "Staying in idle")
			timer.wait_time = rand_range(0.4, 5)
			timer.start()
		STATES.CONV:
			DebugEvents.console_print(tako.logColor, owner.name, "Start conv")
			state_machine.transition_to("StartConv")
