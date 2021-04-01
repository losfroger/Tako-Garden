extends VBoxContainer

onready var scoreLabel = $VBoxContainer/ScoreLabel

func score(number:int) -> void:
	scoreLabel.text = "Score: " + String(number)


func _on_Retry_pressed() -> void:
	get_tree().reload_current_scene()
