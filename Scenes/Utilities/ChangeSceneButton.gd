# Button that changes to the scene you specify with the exported variable
extends Button

export (String, FILE, "*.tscn") var Scene

func _on_ChangeSceneButton_pressed() -> void:
	if Scene != null:
		get_tree().paused = false
		TransitionScreen.transition_scene(Scene)
