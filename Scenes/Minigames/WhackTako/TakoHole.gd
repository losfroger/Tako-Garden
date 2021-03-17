extends Node2D

enum STATE {
	UP,
	DOWN,
}

onready var takoSprite = $TakoSprite
onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer
onready var emote = $Emotes
onready var hurtBox = $Hurtbox/CollisionShape2D

var state = STATE.DOWN
var bonked = false

func _ready() -> void:
	randomize()
	takoSprite.animationTree.active = false
	animationPlayer.play("default")
	timer.wait_time = rand_range(5,10)
	timer.start()


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	timer.stop()
	print("Bonk!")
	emote.emote(emote.EMOTES.circle, 0.5)
	hurtBox.disabled = true
	bonked = true
	animationPlayer.play("down")
	state = STATE.DOWN
	timer.wait_time = rand_range(5,10)
	timer.start()
	bonked = false


func _on_Timer_timeout() -> void:
	match state:
		STATE.UP:
			animationPlayer.play("down")
			if not bonked:
				emote.emote(emote.EMOTES.cross, 0.5)
			bonked = false
			state = STATE.DOWN
			timer.wait_time = rand_range(5,10)
			timer.start()
		STATE.DOWN:
			animationPlayer.play("pop")
			state = STATE.UP
			timer.wait_time = rand_range(0.8, 1.5)
			timer.start()
