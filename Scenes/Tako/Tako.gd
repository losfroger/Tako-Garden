# Tako that shows in the main screen
class_name Tako
extends KinematicBody2D

signal takoUI(remoteTransform, info)
signal arrivedConv()

export var speed_max := 520.0
export var acceleration_max := 1384.0
export var proximity_radius := 100.0
export var logColor: Color = Color.cornflower

# Steering
onready var agent := GSAIKinematicBody2DAgent.new(self)
onready var proximity_takos := GSAIRadiusProximity.new(agent, [], proximity_radius)

var _radius
var _acceleration := GSAITargetAcceleration.new()
var foodSorted: Array
var eat_recently = false

# Nodes
onready var takoSprite = $TakoSprite
onready var collision = $CollisionShape2D
onready var particleEmitter = $ParticleEmitter
onready var stateMachine = $StateMachine
onready var searchFoodArea = $SearchFood
onready var eatFoodArea = $EatArea
onready var emoteSprite = $Emotes
onready var eatTimer = $EatCD

func _ready() -> void:
	proximity_radius *= scale.x

	# Steering setup
	agent.linear_speed_max = speed_max
	agent.linear_acceleration_max = acceleration_max
	agent.linear_drag_percentage = 0.1

	_radius = collision.shape.radius
	agent.bounding_radius = _radius

	proximity_takos.radius = proximity_radius


func set_proximity_agents(agents: Array) -> void:
	proximity_takos.agents = agents


class FoodSorter:
	static func sort_desc_distance(a, b) -> bool:
		if a.distance < b.distance:
			return true
		return false


func _on_SearchFood_body_entered(_body: Node) -> void:
	foodSorted = get_food_sorted()
	if stateMachine.state.name != "Food":
		stateMachine.transition_to("Food")


func get_food_sorted() -> Array:
	var bodySort: Array = []
	for body in searchFoodArea.get_overlapping_bodies():
		if body.is_inside_tree():
			bodySort.append({"body": body,
				"distance": body.global_position.distance_to(global_position)})
	if searchFoodArea.get_overlapping_bodies().size() > 1:
		bodySort.sort_custom(FoodSorter, "sort_desc_distance")
	return bodySort


func _on_EatArea_body_entered(body: Node) -> void:
	DebugEvents.console_print(logColor, name, "Yummy food!")
	particleEmitter.emitting = true
	emoteSprite.emote(emoteSprite.EMOTES.happy, 1.5)
	
	body.queue_free()
	yield(body, "tree_exited")
	foodSorted = get_food_sorted()
	foodSorted.pop_front()
	if stateMachine.state.name == "Food":
		stateMachine.state.update_data()
	eat_recently = true
	eatTimer.start()


func _on_Tako_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.get_action_strength("l_click"):
			var randomEmotes = [
				emoteSprite.EMOTES.happy, emoteSprite.EMOTES.heart, emoteSprite.EMOTES.heart2, 
				emoteSprite.EMOTES.star, emoteSprite.EMOTES.star2, emoteSprite.EMOTES.yay,
				emoteSprite.EMOTES.note 
				]
			randomEmotes.shuffle()
			emoteSprite.emote(randomEmotes[0], 1)
			InterfaceSignals.emit_signal("DeselectedTako")
			InterfaceSignals.connect("DeselectedTako", self, "_on_Deselected")
			emit_signal("takoUI", $RemoteTakoUI,
				{
					"name": self.name,
				})
			takoSprite.outline(true)


func _on_Deselected() -> void:
	takoSprite.outline(false)
	InterfaceSignals.disconnect("DeselectedTako", self, "_on_Deselected")


func _on_EatCD_timeout() -> void:
	eat_recently = false
