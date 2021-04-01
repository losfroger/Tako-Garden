# Small debug / text log thingie
extends Control

onready var ConsoleLog = $VBoxContainer/ConsoleLog

func _ready() -> void:
	DebugEvents.connect("LogSubmited", self, "submit_text")

func submit_text(color:Color, node_name: String, text:String) -> void:
	ConsoleLog.newline()
	ConsoleLog.push_color(color)
	ConsoleLog.append_bbcode("[" + node_name + "]: ")
	ConsoleLog.pop()
	
	ConsoleLog.append_bbcode(text)


func _on_ToggleButton_pressed() -> void:
	ConsoleLog.visible = !ConsoleLog.visible
