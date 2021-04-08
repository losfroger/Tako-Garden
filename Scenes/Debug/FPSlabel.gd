extends CanvasLayer

var enabled = true setget set_enabled
onready var fpsLabel = $FPSlabel

func set_enabled(newValue):
	enabled = newValue
	set_process(enabled)
	fpsLabel.visible = enabled

func _process(_delta: float) -> void:
	fpsLabel.text = "FPS: " + String(Engine.get_frames_per_second())
