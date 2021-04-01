extends Panel

signal closed_configuration()

func _on_CloseBt_pressed() -> void:
	visible = false
	emit_signal("closed_configuration")

