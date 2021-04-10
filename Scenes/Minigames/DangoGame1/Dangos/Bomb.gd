extends RigidBody2D

signal exploded()

onready var explosionRadius = $explosionRadius

func _ready() -> void:
	angular_velocity = rand_range(-10, 10)
	linear_velocity.y = rand_range(-10, 10)


func _on_Bomb_body_entered(_body: Node) -> void:
	var bodies = explosionRadius.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("explosion"):
			body.explosion(global_position)
	emit_signal("exploded")
	queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
