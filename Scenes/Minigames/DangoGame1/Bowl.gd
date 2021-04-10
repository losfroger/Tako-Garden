tool
extends RigidBody2D

onready var impCenter = $impulseArea
onready var collisionPol = $CollisionPolygon2D
onready var polygon = $Polygon2D

func _ready() -> void:
	impCenter.enabled(true)
	polygon.polygon = collisionPol.polygon


func explosion(_explosion_coord: Vector2) -> void:
	if global_position.distance_to(_explosion_coord) < 375:
		impCenter.gravity = -250
		impCenter.modulate = Color("#ff1818")
		yield(get_tree().create_timer(0.2), "timeout")
		impCenter.modulate = Color("#ffffff")
		impCenter.gravity = 100


func disable_impulse():
	impCenter.enabled(false)
