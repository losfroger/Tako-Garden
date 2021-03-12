# Special state, can be triggered during other states,
# might change it so that some states can't be interrupted by
# this one
extends TakoState

export var predict_time = 0.3

onready var food_seek: GSAIPursue
onready var food_blend: GSAIBlend
onready var avoid: GSAIAvoidCollisions


func enter(_msg := {}) -> void:
	DebugEvents.console_print(tako.logColor, owner.name, "Food detected!")

	food_seek = GSAIPursue.new(tako.agent, null, predict_time)
	food_blend = GSAIBlend.new(tako.agent)
	avoid = GSAIAvoidCollisions.new(tako.agent, tako.proximity_takos)

	food_seek.target = _msg.target

	food_blend.add(avoid, 0.6)
	food_blend.add(food_seek, 1)


func physics_update(delta: float) -> void:
	if tako.searchFoodArea.get_overlapping_bodies().size() == 0:
		state_machine.transition_to("Idle")
	food_blend.calculate_steering(tako._acceleration)
	tako.agent._apply_steering(tako._acceleration, delta)
