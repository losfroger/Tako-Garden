extends Button

var _icon_mute = preload("res://Assets/Icons/musicOff.png")
var _icon_not_mute = preload("res://Assets/Icons/musicOn.png")
var _mute = false

func _ready():
	if AudioServer.is_bus_mute(0):
		self.icon = _icon_mute
		_mute = true

func _on_MusicButton_pressed():
	AudioServer.set_bus_mute(0, not _mute)
	_mute = not _mute
	if _mute:
		self.icon = _icon_mute
	else:
		self.icon = _icon_not_mute
