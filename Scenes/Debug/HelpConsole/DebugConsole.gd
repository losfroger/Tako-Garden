# Small debug / text log thingie
extends Control

onready var ConsoleLog = $VBoxContainer/ConsoleLog

func _ready() -> void:
	DebugEvents.connect("LogSubmited", self, "submit_text")

func submit_text(color:Color, node_name: String, text:String) -> void:
	var bbcodeText: String = "[color=#" + color.to_html(false) + "]"
	bbcodeText += "[" + node_name + "]:[/color] "
	bbcodeText += text
	ConsoleLog.bbcode_text += bbcodeText + "\n"


func _on_ToggleButton_pressed():
	ConsoleLog.visible = !ConsoleLog.visible
