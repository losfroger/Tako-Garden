extends Node2D

onready var takoContainer = $Takos
onready var scoreLabel = $Control/VBoxContainer/Score

func _ready() -> void:
	randomize()
	for tako in takoContainer.get_children():
		tako.connect("bonked", self, "add_score")
		tako.connect("missed", self, "reduce_score")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("r_click"):
		$Takos/TakoWhack.animationPlayer.play("pop")

		
func add_score():
	scoreLabel.addScore(100)


func reduce_score():
	scoreLabel.addScore(-25)
