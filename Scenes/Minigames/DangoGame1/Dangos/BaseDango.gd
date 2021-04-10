extends RigidBody2D

export var greatest_force = 300


func _ready() -> void:
	angular_velocity = rand_range(-10, 10)
	linear_velocity.y = rand_range(-50, 50)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func final_friction() -> void:
	physics_material_override.friction = 1.0
	physics_material_override.rough = true


func explosion(explosion_coord: Vector2) -> void:
	var vec = Vector2.ZERO
	
	var auxVal = 7000
	var divider = Vector2(auxVal, auxVal)
	
	vec = divider / (global_position - explosion_coord)
	
	vec.x = clamp(vec.x, -greatest_force, greatest_force)
	vec.y = clamp(vec.y, -greatest_force, greatest_force)
	
	apply_central_impulse(vec)

