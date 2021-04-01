extends Button


func _on_RetryButton_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
