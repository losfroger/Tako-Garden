extends TakoState

var num_spins: int
var spinTime = 0.4

onready var tween = $Tween

func enter(_msg := {}) -> void:
	num_spins = randi() % 3 + 2
	tako.takoSprite.animation("idle")
	
	tween.interpolate_property(tako.takoSprite, "rotation", 0, deg2rad(num_spins * 360), spinTime * num_spins, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT )
	tween.start()

func exit() -> void:
	tween.stop_all()
	tako.takoSprite.rotation = 0

func _on_Tween_tween_completed(object, key):
	state_machine.transition_to("Idle")
