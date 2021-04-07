extends Control

var mouseMode = Input.MOUSE_MODE_VISIBLE

onready var blurScreen = $BlurScreen
onready var optionsPanel = $ConfigPanel
onready var continueButton = $VBoxContainer/Buttons/Continue

func show():
	blurScreen.show()
	visible = true

func unpause():
	Input.set_mouse_mode(mouseMode)
	blurScreen.hide()
	visible = false
	get_tree().paused = false


func _on_Continue_pressed() -> void:
	unpause()


func _on_Options_pressed() -> void:
	continueButton.disabled = true
	optionsPanel.visible = true


func _on_ConfigPanel_closed_configuration() -> void:
	continueButton.disabled = false