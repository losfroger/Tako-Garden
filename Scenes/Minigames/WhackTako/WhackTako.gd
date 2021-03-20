extends Node2D

onready var takoContainer = $Takos
onready var scoreLabel = $CanvasLayer/Control/VBoxContainer/Score
onready var gameOverScreen = $CanvasLayer/Control/GameOverScreen
onready var blurRect = $CanvasLayer/Control/BlurRect

# TODO: Change speed when gaining more points so the takos are
# harder to hit
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	randomize()
	for tako in takoContainer.get_children():
		tako.connect("bonked", self, "add_score")
		tako.connect("missed", self, "reduce_score")


func add_score() -> void:
	scoreLabel.addScore(100)


func reduce_score() -> void:
	scoreLabel.addScore(-25)


func _on_CountDownTimer_end_timer() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	gameOverScreen.score(scoreLabel.score)
	gameOverScreen.visible = true
	blurRect.visible = true
