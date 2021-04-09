extends RigidBody2D

func _ready() -> void:
	angular_velocity = rand_range(-5, 5)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
