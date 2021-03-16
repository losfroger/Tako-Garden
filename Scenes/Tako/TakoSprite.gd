extends Sprite

onready var animationPlayer = $AnimationPlayer
var shaderOutline = preload("res://Source/Shaders/Outline.tres")

func _ready() -> void:
	shaderOutline.set_shader_param("line_thickness", 10)

func outline(show = false):
	if show:
		material = shaderOutline
		z_index = 5
	else:
		z_index = 0
		material = null
