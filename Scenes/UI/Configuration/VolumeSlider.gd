extends HSlider

export var audio_bus_name := "Master"
onready var _bus := AudioServer.get_bus_index(audio_bus_name)
onready var soundTest = $soundTest

var _readyVolume = false

func _ready() -> void:
	soundTest.bus = audio_bus_name
	value = db2linear(AudioServer.get_bus_volume_db(_bus))


func _on_VolumeSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear2db(value))
	if _readyVolume:
		soundTest.play()
	_readyVolume = true
