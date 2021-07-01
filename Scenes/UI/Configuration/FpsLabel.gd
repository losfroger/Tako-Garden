extends CheckButton


func _ready() -> void:
	pressed = FPSlabel.enabled

func _on_FpsLabel_pressed() -> void:
	ConfigManager.set_setting("display", "show_fps", pressed)
	FPSlabel.enabled = pressed
