extends Position2D

onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	animationPlayer.play("start")
