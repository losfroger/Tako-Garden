extends Button

signal IdPressed(id)

var id: String = "0"

func _on_IdButton_pressed() -> void:
	emit_signal("IdPressed", id)
