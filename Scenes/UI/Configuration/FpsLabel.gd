extends CheckButton


func _ready() -> void:
	pressed = FPSlabel.enabled

func _on_FpsLabel_pressed() -> void:
	FPSlabel.enabled = pressed
