extends Control

onready var scoreLabel = $VBoxContainer/ScoreLabel
onready var blurScreen = $BlurScreen

func show(score = 0):
	get_tree().paused = true
	visible = true
	score(score)
	blurScreen.show()


func score(number:int) -> void:
	scoreLabel.text = "Score: " + String(number)


func _on_Retry_pressed() -> void:
	get_tree().reload_current_scene()
