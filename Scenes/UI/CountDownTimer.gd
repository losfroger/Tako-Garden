extends RichTextLabel

signal end_timer()

onready var timer = $Timer
onready var randomAudio = $RandomAudioStreamPlayer

export var seconds = 60 setget set_seconds
export var start_ticking = 10

func _ready() -> void:
	self.seconds = seconds


func set_seconds(new_seconds: int) -> void:
	update_seconds(new_seconds)
	seconds = new_seconds


func _on_Timer_timeout() -> void:
	self.seconds -= 1
	if seconds <= start_ticking:
		randomAudio.play()
	if seconds == 0:
		emit_signal("end_timer")
		timer.stop()

func update_seconds(newSeconds):
	clear()
	push_align(RichTextLabel.ALIGN_CENTER)
	append_bbcode("Time: ")
	var textNumber = ""
	
	var stringNewSec = String(newSeconds)
	var stringOldSec = String(seconds)
	var numbers = []
	for i in range(stringNewSec.length()):
		if i < stringOldSec.length():
			if stringNewSec[i] != stringOldSec[i]:
				textNumber += "[count]%s[/count]"
			else:
				textNumber += "%s"
		else:
				textNumber += "%s"
		numbers.append(stringNewSec[i])
	textNumber = textNumber % numbers
	append_bbcode(textNumber)
	pop()

