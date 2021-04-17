extends ColorRect

signal hidden()

export var blurAmount = 3.0
export var time = 0.5

onready var shader = preload ("res://Source/Shaders/BlurScreen.tres")
onready var tween = $Tween

func show():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		material = shader
		visible = true
		tween.interpolate_property(self.material, 
			"shader_param/amount", 
			0,
			blurAmount,
			time,
			Tween.TRANS_CUBIC,
			Tween.EASE_OUT) 
		tween.start()


func hide():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		tween.interpolate_property(self.material, 
				"shader_param/amount", 
				blurAmount,
				0,
				time * (2.0/3.0)) 
		tween.start()
		
		yield(tween, "tween_all_completed")
		
		material = null
		visible = false
	emit_signal("hidden")
