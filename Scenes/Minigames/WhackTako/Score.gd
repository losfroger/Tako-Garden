extends Label

var score = 0
func addScore(addNum) -> void:
	score += addNum
	score = max(0,score)
	text = "Score: " + String(score)
