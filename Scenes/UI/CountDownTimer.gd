extends Label

signal end_timer()

onready var timer = $Timer
export var seconds = 60

func _ready() -> void:
	text = "Time: " + String(seconds)


func _on_Timer_timeout() -> void:
	seconds -= 1
	text = "Time: " + String(seconds)
	if seconds == 0:
		emit_signal("end_timer")
		timer.stop()
