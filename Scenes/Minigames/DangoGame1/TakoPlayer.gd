extends KinematicBody2D

onready var basket = $Basket

export var MAX_SPEED = 90
export var ACCELERATION = 600
export var FRICTION = 500

var _velocity = Vector2.ZERO
var _input_vector = Vector2.ZERO

func disable_controls():
	basket.constant_linear_velocity = Vector2.ZERO
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	get_direction()
	
	if _input_vector != Vector2.ZERO:
		_velocity = _velocity.move_toward(_input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	basket.constant_linear_velocity = _velocity
	move_and_slide(_velocity)

func get_direction():
	_input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_input_vector.y = 0.0

