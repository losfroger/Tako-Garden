extends Control

signal closed_minigame_selection()

export var idButton: PackedScene
export var buttonFont: Font
export var infoIcon: Texture
export var controlIcon: Texture

var json: Dictionary

onready var buttonContainer = $Panel/MarginContainer/HBoxContainer/Buttons/MarginContainer/ButtonContainer
onready var titleLabel = $Panel/MarginContainer/HBoxContainer/Container/VBoxContainer/TitleLabel
onready var imageRect = $Panel/MarginContainer/HBoxContainer/Container/VBoxContainer/ImageRect
onready var description = $Panel/MarginContainer/HBoxContainer/Container/VBoxContainer/TabContainer/Description
onready var controls = $Panel/MarginContainer/HBoxContainer/Container/VBoxContainer/TabContainer/Controls
onready var playBt = $Panel/MarginContainer/HBoxContainer/Container/PlayButton
onready var tabContainer = $Panel/MarginContainer/HBoxContainer/Container/VBoxContainer/TabContainer

func _ready() -> void:
	tabContainer.set_tab_icon(0, infoIcon)
	tabContainer.set_tab_icon(1, controlIcon)
	
	
	var file = File.new()
	file.open("res://Source/minigames.json", file.READ)
	var jsonTest = file.get_as_text()
	json = JSON.parse(jsonTest).result
	
	loadId("0")
	
	for i in json:
		var button = idButton.instance()
		
		button.add_font_override("font", buttonFont)
		
		button.text = json[i]["name"]
		button.id = i
		
		button.connect("IdPressed", self, "loadId")
		
		buttonContainer.add_child(button)

func loadId(id: String) -> void:
	titleLabel.text = json[id]["name"]
	imageRect.texture = load(json[id]["image"])
	
	description.clear()
	for line in json[id]["description"]:
		description.append_bbcode(line)
		description.newline()
	
	controls.clear()
	for line in json[id]["controls"]:
		controls.append_bbcode(line)
		controls.newline()
	
	playBt.Scene = json[id]["playBt"]
	
	playBt.disabled = true if json[id]["playBt"] == null else false

func _on_IdButton_pressed(id: String) -> void:
	loadId(id)


func _on_CloseButton_pressed() -> void:
	visible = false
	emit_signal("closed_minigame_selection")


func _on_Description_meta_clicked(meta) -> void:
	OS.shell_open(meta)
