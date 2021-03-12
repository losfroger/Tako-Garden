extends Node

signal LogSubmited(color,node_name,text)

func console_print(color: Color, node_name:String, text: String) -> void:
	self.emit_signal("LogSubmited", color, node_name, text)
