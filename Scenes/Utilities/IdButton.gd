# Used in the choose minigame window, it saves it's id and emits it when pressed
# useful because the minigames get loaded from a json
extends Button

signal IdPressed(id)

var id: String = "0"

func _on_IdButton_pressed() -> void:
	emit_signal("IdPressed", id)
