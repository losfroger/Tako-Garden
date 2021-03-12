# State that makes the tako go to a random place on screen
# might change it so it can take a dictonary with the location to go
# and the node to return to
extends TakoState

export var margin: Vector2
export var arrival_tolerance = 80
export var deceleration_radius = 180

onready var target := GSAIAgentLocation.new()
onready var avoid: GSAIAvoidCollisions
onready var seek: GSAIArrive

onready var wander_blend: GSAIBlend


func enter(_msg := {}) -> void:
	DebugEvents.console_print(tako.logColor, owner.name, "Wander")

	avoid = GSAIAvoidCollisions.new(tako.agent, tako.proximity_takos)
	seek = GSAIArrive.new(tako.agent, target)
	wander_blend = GSAIBlend.new(tako.agent)

	seek.arrival_tolerance = arrival_tolerance
	seek.deceleration_radius = deceleration_radius

	var width = ProjectSettings["display/window/size/width"]
	var height = ProjectSettings["display/window/size/height"]
	target.position.x = rand_range(0 + margin.x, width - margin.x)
	target.position.y = rand_range(0 + margin.y, height - margin.y)

	wander_blend.add(seek, 1)
	seek.connect("arrived", self, "_on_arrived")


func physics_update(delta: float) -> void:
	wander_blend.calculate_steering(tako._acceleration)
	tako.agent._apply_steering(tako._acceleration, delta)


func _on_arrived():
	DebugEvents.console_print(tako.logColor, owner.name, "Arrived to target")
	state_machine.transition_to("Idle")
