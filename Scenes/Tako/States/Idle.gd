# This state will decide randomly to get another state
extends TakoState

onready var timer = $Timer

enum STATES {
	WANDER = 0,
	IDLE = 1
}

onready var avoid: GSAIAvoidCollisions

func _ready():
	timer.connect("timeout", self, "timer_end")

func enter(_msg := {}) -> void:
	avoid = GSAIAvoidCollisions.new(tako.agent, tako.proximity_takos)
	DebugEvents.console_print(Color.blueviolet, owner.name, "Idle")
	
	timer.wait_time = rand_range(1, 8)
	timer.start()

func physics_update(delta: float) -> void:
	avoid.calculate_steering(tako._acceleration)
	tako.agent._apply_steering(tako._acceleration, delta)

func timer_end() -> void:
	var random_state = randi() % 2
	match random_state:
		STATES.WANDER:
			state_machine.transition_to("Wander")
		STATES.IDLE:
			DebugEvents.console_print(Color.blueviolet, owner.name, "Staying in idle")
			timer.wait_time = rand_range(0.4, 5)
			timer.start()
