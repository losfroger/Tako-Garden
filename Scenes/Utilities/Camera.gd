# Camera with shake function
extends Camera2D

onready var shakeTween = $ShakeTween
var camera_shake_intensity = 0.0
var camera_shake_duration = 0.0

func shake(intensity: float, duration: float) -> void:
	# Set the shake parameters
	#
	# A good idea here is to add configuration settings that
	# allow the player to turn off shake
	#
	# if player_no_want:
	# 	intensity = 0
	
	print(intensity)
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		shakeTween.interpolate_property(self, 
			"camera_shake_intensity",
			intensity, 0.0, 
			duration, 
			Tween.TRANS_CUBIC, 
			Tween.EASE_OUT)
		shakeTween.start()
		camera_shake_duration = duration


func  _process(delta: float) -> void:
	if camera_shake_duration <= 0:
		# Reset the camera when the shaking is done
		offset = Vector2.ZERO
		camera_shake_intensity = 0.0
		camera_shake_duration = 0.0
		return

	camera_shake_duration -= delta

	offset = Vector2(randf(), randf()) * camera_shake_intensity

