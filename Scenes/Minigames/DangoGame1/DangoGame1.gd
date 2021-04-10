extends Node2D

var items := [
	{"name": "dango", "instance": preload("res://Scenes/Minigames/DangoGame1/Dangos/BaseDango.tscn")},
	{"name": "bomb", "instance": preload("res://Scenes/Minigames/DangoGame1/Dangos/Bomb.tscn")}
]

var probStates := [
	{"item": items[0], "weight": 0.60},
	{"item": items[1], "weight": 0.40}
]
var probClass: WeightedRandom

var dangoInstance = preload("res://Scenes/Minigames/DangoGame1/Dangos/BaseDango.tscn")
var emoteInstance = preload("res://Scenes/Tako/Emotes.tscn")
var coinInstance = preload("res://Scenes/Minigames/DangoGame1/Dangos/Coin.tscn")

onready var dangoNode = dangoInstance.instance()

onready var emote = $Emotes
onready var spawnTimer = $SpawnTimer
onready var spawnTimer2 = $SpawnTimer2
onready var spawnCoin = $SpawnCoin
onready var scoreTimer = $ScoreTimer
onready var dangosParent = $Dangos
onready var takoPlayer = $TakoPlayer
onready var countArea = $TakoPlayer/CountArea
onready var countLabel = $UI/Count
onready var bowl = $Bowl
onready var gameOver = $UI/GameOverScreen

func _ready() -> void:
	yield(TransitionScreen, "transition_complete")
	get_tree().paused = false
	probClass = WeightedRandom.new(probStates)
	spawnTimer.start()
	spawnTimer2.start()


func _input(event: InputEvent) -> void:
	if event.get_action_strength("l_click"):
		var bombInstance = items[0].instance.instance()
		bombInstance.global_position = get_global_mouse_position()
		dangosParent.add_child(bombInstance)
	
	if event.get_action_strength("r_click"):
		var dangoInstance = items[1].instance.instance()
		dangoInstance.global_position = get_global_mouse_position()
		dangosParent.add_child(dangoInstance)
		#body.physics_material_override.bounce = 0.3
		#yield(get_tree().create_timer(0.2), "timeout")
		#body.physics_material_override.bounce = 0.1


func on_bomb_exploded() -> void:
	dangoNode.physics_material_override.bounce = 0.3
	yield(get_tree().create_timer(0.15), "timeout")
	dangoNode.physics_material_override.bounce = 0.1


func new_falling_entity():
	var randomPick = probClass.random_pick()
	
	var newDango:RigidBody2D = randomPick.instance.instance()
	var dangoCoord = GlobalFunctions.randomCord(Vector2(500, 0)) 
	dangoCoord.y = rand_range(-50, -200)
	newDango.global_position = dangoCoord
	
	dangosParent.add_child(newDango)
	
	var newEmote = emoteInstance.instance()
	newEmote.rotation = emote.rotation
	newEmote.scale = emote.scale
	newEmote.z_index = 2
	
	dangosParent.add_child(newEmote)
	newEmote.global_position = emote.global_position
	newEmote.global_position.x = dangoCoord.x
	yield(get_tree().create_timer(0.15), "timeout")
	
	match randomPick.name:
		"dango":
			newEmote.emote(newEmote.EMOTES.circle, 0.8)
		"bomb":
			newDango.connect("exploded", self, "on_bomb_exploded")
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
	
	newCoin.global_position= coords
	dangosParent.add_child(newCoin)
	
	spawnCoin.wait_time = rand_range(10, 20)
	spawnCoin.start()

func _on_CountDownTimer_end_timer() -> void:
	get_tree().call_group("Bombs", "queue_free")
	get_tree().call_group("Dango", "final_friction")
	
	spawnTimer.stop()
	spawnTimer2.stop()
	spawnCoin.stop()
	takoPlayer.disable_controls()
	bowl.disable_impulse()
	
	scoreTimer.start()
	yield(scoreTimer,"timeout")
	
	var check_bodies = true
	var bodies = countArea.get_overlapping_bodies()
	var iterations = 0
	var margin = 10
	# Wait for the bodies to stop moving
	while check_bodies and iterations < 100:
		yield(get_tree().create_timer(0.1), "timeout")
		
		check_bodies = false
		bodies = countArea.get_overlapping_bodies()
		for body in bodies:
			if (body.linear_velocity.y > margin || body.linear_velocity.y < -margin
			 || body.linear_velocity.x > margin || body.linear_velocity.x < -margin):
				check_bodies = true
				break
		iterations += 1
	
	countLabel.text = "Dangos: " + str(len(bodies) - 1)
	countLabel.visible = true
	gameOver.visible = true
