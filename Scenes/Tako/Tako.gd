class_name Tako
extends KinematicBody2D

# Steering
onready var agent := GSAIKinematicBody2DAgent.new(self)
onready var proximity_takos := GSAIRadiusProximity.new(agent, [], proximity_radius)

export var speed_max := 520.0
export var acceleration_max := 1384.0
export var proximity_radius := 100
export var proximity_draw: bool = false

var _radius
var _acceleration := GSAITargetAcceleration.new()

# Nodes
# TODO: Change the TakoSprite to make it more general(?)
onready var animationPlayer = $TakoSprite.animationPlayer
onready var collision = $CollisionShape2D
onready var particleEmitter = $ParticleEmitter
onready var stateMachine = $StateMachine

func _ready() -> void:
	proximity_radius *= scale.x
	
	animationPlayer.play("idle")
	var randomFrame = rand_range(0,0.5)
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

func _on_SearchFood_body_entered(body: Node):
	stateMachine.transition_to("Food", {"target": body.agent})

func _on_SearchFood_body_exited(body: Node):
	stateMachine.transition_to("Idle")

func _on_EatArea_body_entered(body: Node) -> void:
	DebugEvents.ConsolePrint(Color.blueviolet, name, "Yummy food!")
	particleEmitter.emitting = true
	body.queue_free()
