extends Label

var score = 0 setget addScore

func _ready() -> void:
	text = "Score: " + String(score)

func addScore(addNum) -> void:
	score += addNum
	score = max(0,score)
	text = "Score: " + String(score)
