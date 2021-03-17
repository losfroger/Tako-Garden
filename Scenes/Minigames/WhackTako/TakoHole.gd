extends Node2D

signal bonked()
signal missed()

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
	timer.wait_time = rand_range(1,12)
	timer.start()


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	timer.stop()
	print("Bonk!")
	emit_signal("bonked")
	emote.emote(emote.EMOTES.circle, 0.5)
	hurtBox.disabled = true
	bonked = true
	downTako()

func downTako():
	animationPlayer.play("down")
	state = STATE.DOWN
	timer.wait_time = rand_range(5,10)
	timer.start()
	bonked = false

func _on_Timer_timeout() -> void:
	match state:
		STATE.UP:
			if not bonked:
				emote.emote(emote.EMOTES.cross, 0.5)
				emit_signal("missed")
			downTako()
		STATE.DOWN:
			animationPlayer.play("pop")
			state = STATE.UP
			timer.wait_time = rand_range(0.8, 1.5)
			timer.start()


