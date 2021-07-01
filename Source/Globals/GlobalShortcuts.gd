extends CanvasLayer

var _toast_load = preload("res://Scenes/UI/Toast.tscn")

func _ready():
	layer = 1000
	pause_mode = Node.PAUSE_MODE_PROCESS

# TODO: Make fullscreen toggle with F11
func _input(event):
	# Save a screenshot in the screenshots folder
	if event.is_action_pressed("screenshot"):
		# TODO: Make version to save screenshot on HTML
		if OS.get_name() != "HTML5":
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
			
			var toastText = "Screenshot saved at " + ProjectSettings.globalize_path(dir.get_current_dir())
			var toastInstance = _toast_load.instance()
			
			self.add_child(toastInstance)
			
			toastInstance.toast(toastText, 1.5)
			print(toastInstance.text)
