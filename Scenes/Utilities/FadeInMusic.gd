class_name FadeInPlayer
extends AudioStreamPlayer

export (float, -80, 24) var initial_volume = -80
export (float, -80, 24) var _final_volume = 0
export var time = 1.5

onready var volumeTween = $Tween


func _ready() -> void:
	volume_db = -80
	volumeTween.interpolate_property(self, "volume_db", initial_volume, _final_volume, time, Tween.TRANS_EXPO)
	volumeTween.start()
