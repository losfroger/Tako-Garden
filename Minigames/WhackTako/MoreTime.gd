extends Node2D

signal bonked_more_time()

export var time_wait := Vector2(15, 20)

onready var tweenX = $TweenX
onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer
onready var hurtBox = $Position2D/HurtBox/CollisionShape2D
onready var hitSFX = $HitSFX

var speed = 2
var indicator = preload("res://Minigames/WhackTako/UI/TimeIndication.tscn")

func _ready() -> void:
	randomize()
	timer.wait_time = rand_range(time_wait.x, time_wait.y)
	timer.start()


func _on_Timer_timeout() -> void:
	animationPlayer.playback_speed = rand_range(0.7, 1.5)
	animationPlayer.play("float")
	tweenX.interpolate_property(self, "global_position:x", -100, GlobalFunctions.WIDTH + 100, speed)
	tweenX.start()


func _on_HurtBox_area_entered(_area: Area2D) -> void:
	emit_signal("bonked_more_time")
	speed = max(0.5, speed - 0.15)
	hurtBox.set_deferred("disabled", true)
	hitSFX.play()
	var indicatorInst = indicator.instance()
	indicatorInst.global_position = global_position
	get_parent().add_child(indicatorInst)


func _on_TweenX_tween_completed(_object: Object, _key: NodePath) -> void:
	hurtBox.set_deferred("disabled", false)
	timer.wait_time = rand_range(time_wait.x, time_wait.y)
	timer.start()
