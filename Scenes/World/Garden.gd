extends Node

onready var foodLoad = preload("res://Scenes/Interact/Food.tscn")
export var tako_template = preload("res://Scenes/Tako/Tako.tscn")
export var margin = Vector2(70, 70)

onready var takos = $Takos
onready var food = $Food
onready var minigameSelection = $UI/ChooseMinigame
onready var alertGLES = $UI/AlertGLES

onready var shaders = [$ParallaxBackground/Bubbles, 
	$ParallaxBackground/Bubbles2, 
	$ParallaxBackground/Bubbles3,
	$Godray,
	$ParallaxBackground/Godray2,
	$LightParticles,
	$LightParticles2
	]

func _ready() -> void:
	get_tree().paused = false
	
	# Show driver alert in case GLES3 is not detected, and hide
	# the shaders from the menu screen 
	if OS.get_current_video_driver() != OS.VIDEO_DRIVER_GLES3:
		alertGLES.popup_centered()
		for shader in shaders:
			pass
			#shader.visible = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	randomize()
	var tako_agents := []
	
	var probStates := [
	{"item": "tako", "weight": 0.75},
	{"item": "ika", "weight": 0.30},
	{"item": "gold_tako", "weight": 0.08},
	]
	
	var probClass = WeightedRandom.new(probStates)
	
	# Right now the takos are generated randomly each time
	# when saving and loading saves is in place here is where the takos
	# will get loaded
	for _i in range(12):
		var takoInst = tako_template.instance()
		takos.add_child(takoInst, true)

		var randPos = Vector2.ZERO
		var width = ProjectSettings["display/window/size/width"]
		var height = ProjectSettings["display/window/size/height"]
		randPos.x = rand_range(0 + margin.x, width - margin.x)
		randPos.y = rand_range(0 + margin.y, height - margin.y)

		var randScale = rand_range(0.6, 1)

		takoInst.global_position = randPos
		takoInst.scale = Vector2(randScale, randScale)
		takoInst.takoSprite.sprite = probClass.random_pick()

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


func _on_PlayButton_pressed() -> void:
	InterfaceSignals.emit_signal("DeselectedTako")
	minigameSelection.visible = true
