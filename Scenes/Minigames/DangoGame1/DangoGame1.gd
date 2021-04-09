extends Node2D

export (Array, PackedScene) var DangoScenes: Array

onready var spawnTimer = $SpawnTimer
onready var scoreTimer = $ScoreTimer
onready var dangosParent = $Dangos
onready var takoPlayer = $TakoPlayer
onready var countArea = $TakoPlayer/CountArea
onready var countLabel = $UI/Count

func _ready() -> void:
	yield(TransitionScreen, "transition_complete")
	get_tree().paused = false


func _on_SpawnTimer_timeout() -> void:
	randomize()
	DangoScenes.shuffle()
	
	var newDango:RigidBody2D = DangoScenes[0].instance()
	var dangoCoord = GlobalFunctions.randomCord(Vector2(500, 0)) 
	dangoCoord.y = -150
	newDango.global_position = dangoCoord
	
	dangosParent.add_child(newDango)
	spawnTimer.wait_time = rand_range(1.2, 3)
	spawnTimer.start()


func _on_CountDownTimer_end_timer() -> void:
	spawnTimer.stop()
	takoPlayer.disable_controls()
	
	scoreTimer.start()
	yield(scoreTimer,"timeout")
	
	var check_bodies = true
	var bodies = countArea.get_overlapping_bodies()
	var iterations = 0
	while check_bodies and iterations < 100:
		yield(get_tree().create_timer(0.1), "timeout")
		
		check_bodies = false
		bodies = countArea.get_overlapping_bodies()
		for body in bodies:
			if (body.linear_velocity.y > 5 || body.linear_velocity.y < -5
			 || body.linear_velocity.x > 5 || body.linear_velocity.x < -5):
				check_bodies = true
				break
		iterations += 1
	
	
	countLabel.text = "Dangos: " + str(len(bodies))
	countLabel.visible = true
