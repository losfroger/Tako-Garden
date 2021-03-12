extends Node

signal LogSubmited(color,node_name,text)

func ConsolePrint(color: Color, node_name:String, text: String) -> void:
	self.emit_signal("LogSubmited", color, node_name, text)
