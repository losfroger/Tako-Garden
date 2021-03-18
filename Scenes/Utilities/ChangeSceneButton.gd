extends Button

export (String, FILE, "*.tscn") var Scene

func _on_ChangeSceneButton_pressed() -> void:
	var loadScene = load (Scene)
	get_tree().change_scene_to(loadScene)
