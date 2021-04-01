extends Panel

signal closed_configuration()

func _on_CloseBt_pressed() -> void:
	get_tree().paused = false
	visible = false
	emit_signal("closed_configuration")

