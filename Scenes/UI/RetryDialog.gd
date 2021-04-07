extends ConfirmationDialog

func _on_RetryDialog_confirmed() -> void:
	get_tree().reload_current_scene()
