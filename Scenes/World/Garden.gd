extends Node2D

onready var foodLoad = preload("res://Scenes/Interact/Food.tscn")
export var tako_template: PackedScene

onready var takos = $Takos
onready var food = $Food

#1024 x 600
func _ready() -> void:
	randomize()
	var tako_agents := []
	for _i in range (10):
		var takoInst = tako_template.instance()
		takos.add_child(takoInst, true)
		
		var randPos = Vector2.ZERO
		randPos.x = rand_range(0+70,1024-70)
		randPos.y = rand_range(0+70,600-70)
		
		var randScale = rand_range(0.4,0.8)
		
		takoInst.global_position = randPos
		takoInst.scale = Vector2(randScale,randScale)
		
		tako_agents.append(takoInst.agent)
		
	for tako in takos.get_children():
		tako.set_proximity_agents(tako_agents)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var foodInst = foodLoad.instance()
		foodInst.global_position = get_global_mouse_position()
		
		food.add_child(foodInst)
