extends KinematicBody2D

export var MAX_SPEED = 90
export var ACCELERATION = 600
export var FRICTION = 500

var _velocity = Vector2.ZERO
var _input_vector = Vector2.ZERO

var _enabled = true
var bowl: RigidBody2D


func disable_controls():
	_enabled = false


func _physics_process(delta: float) -> void:
	if _enabled:
		get_direction()
	else:
		_input_vector = Vector2.ZERO
	
	if _input_vector != Vector2.ZERO:
		_velocity = _velocity.move_toward(_input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_collide(_velocity)


func explosion(_explosion_coord: Vector2) -> void:
	return
	_enabled = false
	yield(get_tree().create_timer(0.3), "timeout")
	_enabled = true


func get_direction():
	_input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_input_vector.y = 0.0
