extends Area2D

onready var collisionShape = $CollisionShape2D

func _ready() -> void:
	gravity_vec.y = collisionShape.shape.extents.y * 1.3
	$Sprite.position = gravity_vec


func enabled(state: bool) -> void:
	match state:
		true:
			space_override = Area2D.SPACE_OVERRIDE_COMBINE
			modulate = Color("#ffffff")
		false:
			space_override = Area2D.SPACE_OVERRIDE_DISABLED
			modulate = Color("#ff1818")

