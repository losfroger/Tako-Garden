# Special state, can be triggered during other states,
# might change it so that some states can't be interrupted by
# this one
extends TakoState

export var predict_time = 0.3

var targets: Array
var angryEmote: Array

onready var food_seek: GSAIPursue
onready var food_blend: GSAIBlend
onready var avoid: GSAIAvoidCollisions


func enter(_msg := {}) -> void:
	angryEmote = [
		tako.emoteSprite.EMOTES.angry, tako.emoteSprite.EMOTES.angry2,
		tako.emoteSprite.EMOTES.dread, tako.emoteSprite.EMOTES.brokoro,
		]
	DebugEvents.console_print(tako.logColor, owner.name, "Food detected!")

	food_seek = GSAIPursue.new(tako.agent, null, predict_time)
	food_blend = GSAIBlend.new(tako.agent)
	avoid = GSAIAvoidCollisions.new(tako.agent, tako.proximity_takos)

	food_seek.target = tako.foodSorted.pop_front().body.agent

	food_blend.add(avoid, 0.6)
	food_blend.add(food_seek, 1)


func physics_update(delta: float) -> void:
	if tako.searchFoodArea.get_overlapping_bodies().size() == 0:
		var distanceTarget = food_seek.target.position.distance_to(Vector3(tako.global_position.x, tako.global_position.y, 0))
		if tako.eat_recently == false and (distanceTarget < 250) and (randf() * 100) < 15:
			angryEmote.shuffle()
			tako.emoteSprite.emote(angryEmote[0], 1.2)
		state_machine.transition_to("Idle")
	
	food_blend.calculate_steering(tako._acceleration)
	tako.agent._apply_steering(tako._acceleration, delta)


func update_data(_msg := {}) -> void:
	DebugEvents.console_print(tako.logColor, owner.name, 
		"Update data, size: " + String(tako.foodSorted.size()))
	if tako.foodSorted.size() > 0:
		food_seek.target = tako.foodSorted.pop_front().body.agent
	else:
		state_machine.transition_to("Idle")
