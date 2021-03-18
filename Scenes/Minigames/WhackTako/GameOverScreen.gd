extends VBoxContainer

onready var scoreLabel = $VBoxContainer/ScoreLabel

func score(number:int) -> void:
	scoreLabel.text = "Score: " + String(number)
