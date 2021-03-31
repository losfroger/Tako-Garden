extends Sprite

const SPRITES = {
	"tako": preload("res://Assets/Art/Tako/TakoFlap.png"),
	"ika": preload("res://Assets/Art/Tako/IkaFlap.png"),
	"gold_tako": preload("res://Assets/Art/Tako/GoldTakoFlap.png"),
}

onready var animationTree = $AnimationTree

var animation_state_machine: AnimationNodeStateMachinePlayback
var shaderOutline = preload("res://Source/Shaders/Outline.tres")
var sprite:String="tako" setget set_sprite

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


func set_sprite(name: String) -> void:
	if name != sprite:
		sprite = name
		texture = SPRITES.get(name)


func animation(animation: String) -> void:
	animation_state_machine.travel(animation)

