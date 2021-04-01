extends CheckButton


func _ready() -> void:
	pressed = OS.window_fullscreen


func _on_FullScreen_pressed() -> void:
	OS.window_fullscreen = !OS.window_fullscreen
