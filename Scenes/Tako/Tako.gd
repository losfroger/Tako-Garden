class_name Tako
extends KinematicBody2D

export var speed_max := 520.0
export var acceleration_max := 1384.0
export var proximity_radius := 100.0
export var proximity_draw: bool = false
export var logColor: Color = Color.cornflower

# Steering
onready var agent := GSAIKinematicBody2DAgent.new(self)
onready var proximity_takos := GSAIRadiusProximity.new(agent, [], proximity_radius)

var _radius
var _acceleration := GSAITargetAcceleration.new()
var foodSorted: Array

# Nodes
# TODO: Change the TakoSprite to make it more general(?)
onready var animationPlayer = $TakoSprite.animationPlayer
onready var collision = $CollisionShape2D
onready var particleEmitter = $ParticleEmitter
onready var stateMachine = $StateMachine
onready var searchFoodArea = $SearchFood


func _ready() -> void:
	proximity_radius *= scale.x

	animationPlayer.play("idle")
	var randomFrame = rand_range(0, 0.5)
	animationPlayer.seek(randomFrame)

	# Steering setup
	agent.linear_speed_max = speed_max
	agent.linear_acceleration_max = acceleration_max
	agent.linear_drag_percentage = 0.1

	_radius = collision.shape.radius
	agent.bounding_radius = _radius

	proximity_takos.radius = proximity_radius


func _draw():
	if proximity_draw:
		draw_circle(Vector2.ZERO, proximity_radius, "#22ffffff")


func set_proximity_agents(agents: Array) -> void:
	proximity_takos.agents = agents


class FoodSorter:
	static func sort_desc_distance(a, b):
		if a.distance < b.distance:
			return true
		return false


func _on_SearchFood_body_entered(body: Node):
	foodSorted = get_food_sorted()
	if stateMachine.state.name != "Food":
		stateMachine.transition_to("Food")

func get_food_sorted():
	var bodySort: Array
	for body in searchFoodArea.get_overlapping_bodies():
		bodySort.append({"body": body, "distance": body.global_position.distance_to(global_position)})
	if searchFoodArea.get_overlapping_bodies().size() > 1:
		bodySort.sort_custom(FoodSorter, "sort_desc_distance")
	return bodySort

func _on_EatArea_body_entered(body: Node) -> void:
	DebugEvents.console_print(logColor, name, "Yummy food!")
	particleEmitter.emitting = true
	body.queue_free()
	yield(body, "tree_exited")
	foodSorted = get_food_sorted()
	foodSorted.pop_front()
	if stateMachine.state.name == "Food":
		stateMachine.state.update_data()


func _on_SearchFood_body_exited(body: Node) -> void:
	pass # Replace with function body.
