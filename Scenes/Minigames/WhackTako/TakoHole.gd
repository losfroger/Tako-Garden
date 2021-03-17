extends Node2D

onready var takoSprite = $TakoSprite
onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	takoSprite.animationTree.active = false
	animationPlayer.play("default")
