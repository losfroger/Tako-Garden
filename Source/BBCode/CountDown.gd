tool
extends RichTextEffect
class_name RichTextCountDown

var bbcode := "count"

func _process_custom_fx(char_fx: CharFXTransform):
	var inital_height = char_fx.env.get("height", -10.0)
	var speed = char_fx.env.get("speed", 40.0)
	
	var offsetY = min(0, inital_height + char_fx.elapsed_time * speed)
	char_fx.offset = Vector2(0,  offsetY)
	return true

