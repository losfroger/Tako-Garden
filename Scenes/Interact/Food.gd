extends RigidBody2D

onready var agent := GSAISteeringAgent.new()

func _physics_process(_delta: float) -> void:
	_update_agent()

func _update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.linear_velocity.x = linear_velocity.x
	agent.linear_velocity.y = linear_velocity.y
	agent.angular_velocity = angular_velocity
	agent.orientation = rotation

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_InteractZone_area_entered(_area: Area2D) -> void:
	queue_free()
