extends Node2D

onready var playerHammer = $PlayerHammer
onready var initalCountDown = $UI/InitialCountDown

onready var takoContainer = $Takos
onready var moreTime = $MoreTime

onready var timeLabel = $UI/CountDownTimer
onready var scoreLabel = $UI/Score
onready var gameOverScreen = $UI/GameOverScreen
onready var blurRect = $UI/BlurScreen
onready var gitGudSFX = $GitGud
onready var pauseMenu = $UI/PauseMenu

enum TYPE {
	TAKO,
	IKA,
}

var probStates = [
	{"item": TYPE.TAKO, "weight": 1.0},
	{"item": TYPE.IKA, "weight": 0.02},
	]


# TODO: Change speed when gaining more points so the takos are
# harder to hit
func _ready() -> void:
	get_tree().paused = false
	randomize()
	for tako in takoContainer.get_children():
		tako.connect("bonked", self, "add_score")
		tako.connect("missed", self, "reduce_score")
	moreTime.connect("bonked_more_time", self, "add_time")
	
	yield(get_tree().create_timer(0.01), "timeout")
	
	initalCountDown.start()
	yield(initalCountDown, "end_timer")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	playerHammer.visible = true
	playerHammer.global_position = get_global_mouse_position()


func add_score(newScore) -> void:
	scoreLabel.addScore(newScore)


func reduce_score(newScore) -> void:
	scoreLabel.addScore(newScore)


func add_time() -> void:
	timeLabel.seconds += 10


func _on_CountDownTimer_end_timer() -> void:
	gitGudSFX.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	gameOverScreen.score(scoreLabel.score)
	gameOverScreen.visible = true
	
	blurRect.show()


func _unhandled_input(event: InputEvent) -> void:
	if event.get_action_strength("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pauseMenu.show()
		pauseMenu.mouseMode = Input.MOUSE_MODE_HIDDEN
		get_tree().paused = true
