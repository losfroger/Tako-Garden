extends Label

onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	animationPlayer.play("default")


func toast(toastText: String, time: float) -> void:
	text = toastText
	animationPlayer.play("appear")
	yield(animationPlayer, "animation_finished")
	yield(get_tree().create_timer(time), "timeout")
	animationPlayer.play("disappear")
