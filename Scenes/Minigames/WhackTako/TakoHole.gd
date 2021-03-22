extends Node2D

signal bonked(score)
signal missed(score)

enum STATE {
	UP,
	DOWN,
}

var TYPE := {
	"tako": {"name": "tako", "bonk": 100, "miss": -25},
	"ika": {"name": "ika", "bonk": -150, "miss": 100},
}

var probStates := [
	{"item": TYPE.tako, "weight": 1.0},
	{"item": TYPE.ika, "weight": 0.2},
	]


onready var takoSprite = $TakoSprite
onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer
onready var emote = $Emotes
onready var hurtBox = $Hurtbox/CollisionShape2D
onready var sfxPlayer = $BonkSFX

var state = STATE.DOWN
var bonked = false
var probClass: WeightedRandom
var score = 100.0

var bonkScore = 100
var missScore = -25

func _ready() -> void:
	randomize()
	probClass = WeightedRandom.new(probStates)
	takoSprite.animationTree.active = false
	animationPlayer.play("default")
	timer.wait_time = rand_range(1,12)
	timer.start()


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	timer.stop()
	emit_signal("bonked", bonkScore)
	sfxPlayer.play()
	hurtBox.set_deferred("disabled", true)
	bonked = true
	showEmote()
	animationPlayer.play("down")

func downTako():
	state = STATE.DOWN
	timer.wait_time = rand_range(5,10)
	timer.start()
	
	var newState = probClass.random_pick()
	takoSprite.sprite = newState.name
	bonkScore = newState.bonk
	missScore = newState.miss
	
	bonked = false


func showEmote():
	var emoteSign: int
	match bonked:
		true:
			emoteSign = emote.EMOTES.circle if bonkScore >= 0 else emote.EMOTES.cross
		false:
			emoteSign = emote.EMOTES.circle if missScore >= 0 else emote.EMOTES.cross
	emote.emote(emoteSign, 0.5)


func _on_Timer_timeout() -> void:
	match state:
		STATE.UP:
			if not bonked:
				showEmote()
				emit_signal("missed", missScore)
			animationPlayer.play("down")
		STATE.DOWN:
			animationPlayer.play("pop")
			state = STATE.UP
			timer.wait_time = rand_range(0.8, 1.5)
			timer.start()



