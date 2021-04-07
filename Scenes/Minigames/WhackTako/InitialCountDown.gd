extends RichTextLabel

signal end_timer()

export var timeCountdown = 5

onready var clockSound = $ClockSound
onready var timer = $Timer

func start() -> void:
	get_tree().paused = true
	clockSound.play()
	clear()
	push_align(RichTextLabel.ALIGN_CENTER)
	append_bbcode("[count]" + str(timeCountdown) + "[count]")


func _on_Timer_timeout() -> void:
	timeCountdown -= 1
	
	clear()
	push_align(RichTextLabel.ALIGN_CENTER)
	
	if timeCountdown < 0:
		visible = false
		get_tree().paused = false
		emit_signal("end_timer")
		timer.stop()
	elif timeCountdown == 0:
		clockSound.play()
		append_bbcode("[count]" + "Go!" + "[count]")
	else:
		clockSound.play()
		append_bbcode("[count]" + str(timeCountdown) + "[count]")
