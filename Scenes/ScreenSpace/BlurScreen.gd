extends ColorRect

onready var shader = preload ("res://Source/Shaders/BlurScreen.tres")

func show():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		material = shader
		visible = true

func hide():
	material = null
	visible = false
