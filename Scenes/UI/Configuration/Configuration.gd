extends Panel

signal closed_configuration()

onready var firstButton = $VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/FullScreen

func _on_CloseBt_pressed() -> void:
	visible = false
	ConfigManager.save_settings_file()
	emit_signal("closed_configuration")


func focus() -> void:
	firstButton.grab_focus()
