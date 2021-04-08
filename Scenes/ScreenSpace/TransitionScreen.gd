extends CanvasLayer

signal transition_complete()

var originalSoundVolume
var _bus =  AudioServer.get_bus_index("Master")

onready var tween = $Tween
onready var volumeTween = $VolumeTween
onready var transition = $Control/TransitionGradient

# Code mostly to help test scenes that need the transition_complete signal to continue
func _ready() -> void:
	yield(get_tree().create_timer(0.2), "timeout")
	emit_signal("transition_complete")


func transition_scene(new_scene: String, time_in = 2.0, time_out = 1.5):
	get_tree().paused = true
	
	originalSoundVolume = db2linear(AudioServer.get_bus_volume_db(_bus))
	
	volumeTween.interpolate_method(self, "interpolate_volume", originalSoundVolume, 0, time_in/2)
	volumeTween.start()
	
	tween.interpolate_property(transition.material, "shader_param/progress", 0, 1, time_in, Tween.TRANS_CUBIC, Tween.EASE_OUT) 
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	get_tree().change_scene(new_scene)
	
	volumeTween.interpolate_method(self, "interpolate_volume", 0, originalSoundVolume, time_out/2)
	volumeTween.start()
	
	tween.interpolate_property(transition.material, "shader_param/progress", 1, 0, time_out, Tween.TRANS_CUBIC, Tween.EASE_OUT) 
	tween.start()
	yield(tween, "tween_all_completed")
	
	emit_signal("transition_complete")


func interpolate_volume(volume):
	AudioServer.set_bus_volume_db(_bus, linear2db(volume))


func reload_scene(time = 1.5):
	get_tree().paused = true
	
	volumeTween.interpolate_method(self, "interpolate_volume", originalSoundVolume, 0, time/2)
	volumeTween.start()
	
	tween.interpolate_property(transition.material, "shader_param/progress", 0, 1, time, Tween.TRANS_CUBIC, Tween.EASE_OUT) 
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	get_tree().reload_current_scene()
	
	volumeTween.interpolate_method(self, "interpolate_volume", 0, originalSoundVolume, time/2)
	volumeTween.start()
	
	tween.interpolate_property(transition.material, "shader_param/progress", 1, 0, time, Tween.TRANS_CUBIC, Tween.EASE_OUT) 
	tween.start()
	yield(tween, "tween_all_completed")
	
	emit_signal("transition_complete")
