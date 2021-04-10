tool
extends RigidBody2D

onready var impCenter = $impulseArea
onready var collisionPol = $CollisionPolygon2D
onready var polygon = $Polygon2D
onready var gravityTween = $GravityTween

func _ready() -> void:
	impCenter.enabled(true)
	polygon.polygon = collisionPol.polygon


func explosion(_explosion_coord: Vector2) -> void:
	if global_position.distance_to(_explosion_coord) < 325:
		impCenter.gravity = -250 + (0.1 * global_position.distance_to(_explosion_coord))
		impCenter.modulate = Color("#ff1818")
		print("Gravity: ", impCenter.gravity, " Distance:", global_position.distance_to(_explosion_coord))
		yield(get_tree().create_timer(0.3), "timeout")
		impCenter.modulate = Color("#ffffff")
		gravityTween.interpolate_property(impCenter, "gravity", impCenter.gravity, 225, 0.2)
		gravityTween.start()

func disable_impulse():
	impCenter.enabled(false)
