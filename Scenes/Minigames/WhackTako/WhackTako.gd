extends Node2D

onready var takoContainer = $Takos
onready var moreTime = $MoreTime

onready var timeLabel = $UI/CountDownTimer
onready var scoreLabel = $UI/Score
onready var gameOverScreen = $UI/GameOverScreen
onready var blurRect = $UI/BlurRect
onready var gitGudSFX = $GitGud

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
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	randomize()
	for tako in takoContainer.get_children():
		tako.connect("bonked", self, "add_score")
		tako.connect("missed", self, "reduce_score")
	moreTime.connect("bonked_more_time", self, "add_time")


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
	blurRect.visible = true
