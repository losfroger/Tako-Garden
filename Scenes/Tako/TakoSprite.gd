extends Sprite

onready var animationTree = $AnimationTree

var animation_state_machine: AnimationNodeStateMachinePlayback
var shaderOutline = preload("res://Source/Shaders/Outline.tres")

func _ready() -> void:
	shaderOutline.set_shader_param("line_thickness", 10)
	
	animationTree.active = true
	animation_state_machine = animationTree["parameters/playback"]
	
	var randomFrame = rand_range(0, 0.5)
	animationTree.advance(randomFrame)


func outline(show = false):
	if show:
		material = shaderOutline
		z_index = 5
	else:
		z_index = 0
		material = null


func animation(animation: String):
	animation_state_machine.travel(animation)

