extends Button

export (String, FILE, "*.tscn") var Scene

func _on_ChangeSceneButton_pressed() -> void:
	get_tree().paused = false
	var loadScene = load (Scene)
	get_tree().change_scene_to(loadScene)
