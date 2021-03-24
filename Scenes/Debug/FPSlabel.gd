extends Label

func _process(delta: float) -> void:
	text = "FPS: " + String(Engine.get_frames_per_second())
