extends MenuButton

var mouseMode = Input.MOUSE_MODE_VISIBLE

export var pause = true
export var exitIcon: Texture

onready var popup:PopupMenu = get_popup()
onready var configPanel = $ConfigPanel

func _ready() -> void:
	if OS.get_name() != "HTML5":
		popup.add_item("Exit")
		popup.set_item_icon(1, exitIcon)
	
	get_popup().connect("id_pressed", self, "_on_PopupMenu_id_pressed")


func _on_PopupMenu_id_pressed(id: int) -> void:
	match popup.get_item_text(id):
		"Options":
			get_tree().paused = pause
			configPanel.visible = true
			configPanel.focus()
			disabled = true
		"Exit":
			get_tree().quit()


func _on_ConfigPanel_closed_configuration() -> void:
	disabled = false
