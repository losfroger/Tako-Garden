extends Node

onready var foodLoad = preload("res://Scenes/Interact/Food.tscn")
export var tako_template: PackedScene
export var margin = Vector2(70, 70)

onready var takos = $Takos
onready var food = $Food


func _ready() -> void:
	randomize()
	var tako_agents := []
	for _i in range(10):
		var takoInst = tako_template.instance()
		takos.add_child(takoInst, true)

		var randPos = Vector2.ZERO
		var width = ProjectSettings["display/window/size/width"]
		var height = ProjectSettings["display/window/size/height"]
		randPos.x = rand_range(0 + margin.x, width - margin.x)
		randPos.y = rand_range(0 + margin.y, height - margin.y)

		var randScale = rand_range(0.4, 0.8)

		takoInst.global_position = randPos
		takoInst.scale = Vector2(randScale, randScale)

		takoInst.connect("takoUI", $TakoUI, "newLocation")

		tako_agents.append(takoInst.agent)

	for tako in takos.get_children():
		tako.set_proximity_agents(tako_agents)


func _unhandled_input(event: InputEvent) -> void:
	if event.get_action_strength("r_click"):
		var foodInst = foodLoad.instance()
		foodInst.global_position = event.position

		food.add_child(foodInst)
		InterfaceSignals.emit_signal("DeselectedTako")
