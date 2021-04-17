extends ColorRect

signal hidden()

export var blurAmount = 3.0
export var time = 0.5

onready var shader = preload ("res://Source/Shaders/BlurScreen.tres")
onready var tween = $Tween

func _ready():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		material = shader
		material.set_shader_param("amount", 0)


func show():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
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
				time / 2) 
		tween.start()
		
		yield(tween, "tween_all_completed")
		
		visible = false
	emit_signal("hidden")
