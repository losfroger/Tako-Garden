# This state will decide randomly to get another state
extends TakoState

onready var timer = $Timer

enum STATES {
	WANDER,
	IDLE,
	CONV,
	SIT,
	SPIN,
}

var probStates = [
	{"item": STATES.WANDER, "weight": 2.0},
	{"item": STATES.IDLE, "weight": 2.0},
	{"item": STATES.CONV, "weight": 0.03},
	{"item": STATES.SIT, "weight": 0.1},
	{"item": STATES.SPIN, "weight": 0.08},
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
		STATES.SIT:
			DebugEvents.console_print(tako.logColor, owner.name, "Going to sit")
			var randomCoord = GlobalFunctions.randomCord(Vector2(100,30))
			randomCoord.y = 1000
			var msg = {
				"target": randomCoord,
				"return_to": "Sit",
				"arrivalT": 50,
				"decRad": 200,
				"timer": 10,
			}
			state_machine.transition_to("Move", msg)
		STATES.SPIN:
			DebugEvents.console_print(tako.logColor, owner.name, "Time to spin!")
			state_machine.transition_to("Spin")
