extends Node

signal loaded_settings()
signal changed_settings()
signal loaded_languages()
const SAVE_PATH = "user://config.cfg"

var _config_file:ConfigFile = ConfigFile.new()
var _settings = {
	"display" : {
		"fullscreen": true,
		"show_fps": false,
	},
	"sound" : {
		"Master": 1.0,
		"Music": 1.0,
		"SFX": 1.0,
	}
}
var _default_settings = _settings.duplicate(true)
var loaded_languages:Array = []

func _ready() -> void:
	load_settings_file()
	apply_settings()
	
	emit_signal("loaded_settings")

func save_settings_file() -> void:
	for section in _settings.keys():
		for key in _settings[section]:
			_config_file.set_value(section, key, _settings[section][key])
	_config_file.save(SAVE_PATH)


func load_settings_file() -> void:
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		var error = _config_file.load(SAVE_PATH)
		if error != OK:
			print("Error loading config file, error code #", error)
			return
		
		for section in _settings.keys():
			for key in _settings[section]:
				_settings[section][key] = _config_file.get_value(section, key)
	else:
		save_settings_file()


func apply_settings() -> void:
	OS.window_fullscreen = get_setting("display", "fullscreen")
	FPSlabel.enabled = get_setting("display", "show_fps")
	
	for channel in _settings["sound"]:
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index(channel), 
			linear2db(get_setting("sound", channel))
		)


func restore_settings() -> void:
	_settings = _default_settings.duplicate(true)
	get_tree().set_auto_accept_quit(not get_setting("config", "dialog_quit"))
	OS.window_size = get_setting("config", "window_size")
	emit_signal("changed_settings")


func get_setting(category:String, key:String):
	return _settings[category][key]


func set_setting(category:String, key:String, value) -> void:
	_settings[category][key] = value
