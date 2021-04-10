extends Sprite

signal animation_finished()

enum EMOTES {
	blank, dot1, dot2, dot3, brokoro, heart,
	heart2, exclamation2, exclamation, question, z, z2,
	dread, happy, sad, angry, yay, star,
	star2, note, sweat, sweat2, angry2, dollar,
	swirl, cross, circle, idea, laugh, cloud
}

onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer

func _ready() -> void:
	animationPlayer.play("default")

func emote(emote, duration: float) -> void:
	self.frame = emote
	if timer.time_left > 0:
		timer.stop()
	else:
		animationPlayer.play("appear")
	timer.wait_time = duration
	timer.start()


func _on_Timer_timeout() -> void:
	animationPlayer.play("dissappear")
	yield(animationPlayer,"animation_finished")
	emit_signal("animation_finished")
