extends RigidBody2D

signal bowl_exploded(distanceExplosion)

onready var impCenter = $impulseArea
onready var collisionPol = $CollisionPolygon2D
onready var polygon = $Polygon2D
onready var gravityTween = $GravityTween

func _ready() -> void:
	impCenter.enabled(true)
	polygon.polygon = collisionPol.polygon


func explosion(_explosion_coord: Vector2) -> void:
	var distance = global_position.distance_to(_explosion_coord)
	emit_signal("bowl_exploded", distance)
	
	if distance < 300:	
		impCenter.gravity = -300
		impCenter.modulate = Color("#ff1818")
		yield(get_tree().create_timer(0.2), "timeout")
		impCenter.modulate = Color("#ffffff")
		gravityTween.interpolate_property(impCenter, "gravity", impCenter.gravity, 225, 0.1)
		gravityTween.start()

func disable_impulse():
	impCenter.enabled(false)
