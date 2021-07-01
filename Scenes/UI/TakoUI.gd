# Menu that shows up when you select a tako
extends Node2D

var currentRemote: RemoteTransform2D = null

onready var buttonContainer = $ButtonContainer

func _ready() -> void:
	InterfaceSignals.connect("DeselectedTako", self, "_deselected")

func newLocation(remoteTransform, _info) -> void:
	self.visible = true
	if currentRemote != null:
		currentRemote.remote_path = ""
	
	remoteTransform = remoteTransform as RemoteTransform2D
	remoteTransform.remote_path = self.get_path()
	currentRemote = remoteTransform

func _deselected() -> void:
	self.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.get_action_strength("l_click"):
		var evLocal = make_input_local(event)
		if !Rect2(Vector2(0,0), buttonContainer.rect_size).has_point(evLocal.position):
			InterfaceSignals.emit_signal("DeselectedTako")
