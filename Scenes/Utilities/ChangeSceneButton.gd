extends Button

export (String, FILE, "*.tscn") var Scene

func _on_ChangeSceneButton_pressed() -> void:
	if Scene != null:
		get_tree().paused = false
		TransitionScreen.transition_scene(Scene)
