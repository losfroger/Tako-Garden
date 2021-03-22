extends Sprite

const SPRITES = {
	"tako": "res://Assets/Art/Tako/TakoFlap.png",
	"ika": "res://Assets/Art/Tako/IkaFlap.png",
}

onready var animationTree = $AnimationTree

var animation_state_machine: AnimationNodeStateMachinePlayback
var shaderOutline = preload("res://Source/Shaders/Outline.tres")

func _ready() -> void:
	shaderOutline.set_shader_param("line_thickness", 10)
	
	animationTree.active = true
	animation_state_machine = animationTree["parameters/playback"]
	
	var randomFrame = rand_range(0, 0.5)
	animationTree.advance(randomFrame)


func outline(show:bool = false) -> void:
	if show:
		material = shaderOutline
		z_index = 5
	else:
		z_index = 0
		material = null


func change_sprite(name: String) -> void:
	var newSprite = load(SPRITES.get(name))
	texture = newSprite


func animation(animation: String) -> void:
	animation_state_machine.travel(animation)

