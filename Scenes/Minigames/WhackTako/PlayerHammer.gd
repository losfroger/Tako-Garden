extends Node2D


onready var animationPlayer = $AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("l_click"):
		animationPlayer.play("hit")


func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()



func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "hit":
		animationPlayer.play("default")
