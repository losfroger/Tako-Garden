extends Node2D

onready var items := [
	{"name": "dango", "instance": dangoInstance},
	{"name": "bomb", "instance": bombInstance}
]

onready var probStates := [
	{"item": items[0], "weight": 0.65},
	{"item": items[1], "weight": 0.35}
]
var probClass: WeightedRandom

export var dangoInstance: PackedScene
export var emoteInstance: PackedScene
export var coinInstance: PackedScene
export var bombInstance: PackedScene

onready var dangoNode = dangoInstance.instance()

onready var emote = $Emotes
# Timers
onready var spawnTimer = $SpawnTimer
onready var spawnTimer2 = $SpawnTimer2
onready var spawnCoin = $SpawnCoin
onready var scoreTimer = $ScoreTimer
onready var dangosParent = $Dangos

onready var takoPlayer = $TakoPlayer
onready var countArea = $TakoPlayer/CountArea
onready var bowl = $Bowl

onready var camera = $Camera

# UI
onready var pauseMenu = $UI/PauseMenu
onready var emotesParent = $UI/EmoteGroup
onready var countLabel = $UI/Count
onready var gameOver = $UI/GameOverScreen
onready var scoreLabel = $UI/Score
onready var countTween = $CountTween

func _ready() -> void:
	yield(TransitionScreen, "transition_complete")
	get_tree().paused = false
	probClass = WeightedRandom.new(probStates)
	spawnTimer.start()
	spawnTimer2.start()


func _unhandled_input(event: InputEvent) -> void:
	# Code to spawn thingies
	if event.get_action_strength("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pauseMenu.show()
		pauseMenu.mouseMode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
	
	if event.get_action_strength("r_click"):
		var newBomb = items[1].instance.instance()
		newBomb.global_position = get_global_mouse_position()
		newBomb.connect("exploded", self, "_on_bomb_exploded")
		dangosParent.add_child(newBomb)
	
	if event.get_action_strength("l_click"):
		var newDango = items[0].instance.instance()
		newDango.global_position = get_global_mouse_position()
		dangosParent.add_child(newDango)


func new_falling_entity():
	var randomPick = probClass.random_pick()
	
	var newDango:RigidBody2D = randomPick.instance.instance()
	var dangoCoord = GlobalFunctions.randomCord(Vector2(580, 0)) 
	dangoCoord.y = rand_range(-50, -400)
	newDango.global_position = dangoCoord
	
	if newDango != null:
		if newDango.is_in_group("Bombs"):
			newDango.connect("exploded", self, "_on_bomb_exploded")
	
	dangosParent.add_child(newDango)
	
	var newEmote = emoteInstance.instance()
	newEmote.rotation = emote.rotation
	newEmote.scale = emote.scale
	
	emotesParent.add_child(newEmote)
	newEmote.global_position = emote.global_position
	newEmote.global_position.x = dangoCoord.x
	yield(get_tree().create_timer(0.15), "timeout")
	
	match randomPick.name:
		"dango":
			newEmote.emote(newEmote.EMOTES.circle, 0.8)
		"bomb":
			newEmote.emote(newEmote.EMOTES.cross, 0.8)
	newEmote.connect("animation_finished", newEmote, "queue_free")


func _on_SpawnTimer_timeout() -> void:
	new_falling_entity()
	
	spawnTimer.wait_time = rand_range(0.5, 2)
	spawnTimer.start()


func _on_SpawnTimer2_timeout() -> void:
	new_falling_entity()
	
	spawnTimer2.wait_time = rand_range(3, 5)
	spawnTimer2.start()


func _on_SpawnCoin_timeout() -> void:
	var newCoin = coinInstance.instance()
	
	var coords = takoPlayer.global_position
	var walls_width = 200
	
	coords.x = -5000
	while coords.x < 0.0 + walls_width or coords.x > GlobalFunctions.WIDTH - walls_width: 
		coords.x = takoPlayer.global_position.x + (
			rand_range(300, 600) * pow(-1, randi() % 5))
	
	newCoin.global_position = coords
	dangosParent.add_child(newCoin)
	
	newCoin.connect("collected", scoreLabel, "addScore")
	
	spawnCoin.wait_time = rand_range(10, 20)
	spawnCoin.start()

func _on_CountDownTimer_end_timer() -> void:
	scoreLabel.visible = false
	
	get_tree().call_group("Bombs", "queue_free")
	get_tree().call_group("Dango", "final_friction")
	
	spawnTimer.stop()
	spawnTimer2.stop()
	spawnCoin.stop()
	takoPlayer.disable_controls()
	
	scoreTimer.start()
	yield(scoreTimer,"timeout")
	
	var check_bodies = true
	var bodies = countArea.get_overlapping_bodies()
	var iterations = 0
	var margin = 12
	# Wait for the bodies to stop moving
	while check_bodies and iterations < 60:
		yield(get_tree().create_timer(0.1), "timeout")
		
		check_bodies = false
		bodies = countArea.get_overlapping_bodies()
		for body in bodies:
			if (body.linear_velocity.y > margin || body.linear_velocity.y < -margin
			 || body.linear_velocity.x > margin || body.linear_velocity.x < -margin):
				check_bodies = true
				break
		iterations += 1
	
	countLabel.visible = true
	countTween.interpolate_method(self, "dangoCountAnimation", 0, len(bodies) - 1, 2.0,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	countTween.start()
	
	yield(countTween, "tween_all_completed")
	scoreLabel.addScore(150 * (len(bodies) - 1))
	
	gameOver.show(scoreLabel.score)

func dangoCountAnimation(number: int):
	countLabel.text = "Dangos: " + str(number)


func _on_bomb_exploded(bombCoord: Vector2):
	var distanceExplosion = bowl.global_position.distance_to(bombCoord)
	#print(distanceExplosion)
	camera.shake(range_lerp(distanceExplosion, 10, 600, 50.0, 5.0), 0.8)


func _on_Bowl_bowl_exploded(distanceExplosion) -> void:
	dangoNode.physics_material_override.bounce = 0.3
	yield(get_tree().create_timer(0.15), "timeout")
	dangoNode.physics_material_override.bounce = 0.05