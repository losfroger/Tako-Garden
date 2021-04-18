extends Node

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event):
	if event.is_action_pressed("screenshot"):
		var screenshot_dir = "user://screenshots/"
		var dir = Directory.new()
		
		if dir.dir_exists(screenshot_dir):
			dir.open(screenshot_dir)
		else:
			dir.make_dir(screenshot_dir)
			dir.open(screenshot_dir)
		
		var dateTime = OS.get_datetime()
		var screenshotName = "screenshot_" + String(dateTime.month) + "-" + \
			String(dateTime.day) + "_" + String(dateTime.hour) + "-" + \
			String(dateTime.minute) + "-" + String(dateTime.second)
		
		var image:Image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png(dir.get_current_dir() + "/" + screenshotName + ".png")
		print("Screenshot captured at " + ProjectSettings.globalize_path(dir.get_current_dir()))
