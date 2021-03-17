extends Node2D

func _ready() -> void:
	randomize()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("r_click"):
		$Takos/TakoWhack.animationPlayer.play("pop")
