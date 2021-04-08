extends ConfirmationDialog

func _on_RetryDialog_confirmed() -> void:
	TransitionScreen.reload_scene()
