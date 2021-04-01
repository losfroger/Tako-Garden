extends Node2D

signal bonked(score)
signal missed(score)

enum STATE {
	UP,
	DOWN,
}

var TYPE := {
	"tako": {"name": "tako", "bonk": 100, "miss": -25, "timeUp": [0.9,1.5]},
	"ika": {"name": "ika", "bonk": -150, "miss": 100, "timeUp": [0.7,1.1]},
	"gold_tako": {"name": "gold_tako", "bonk": 300, "miss": 0, "timeUp": [0.6,0.65]},
}

var probStates := [
	{"item": TYPE.tako, "weight": 0.85},
	{"item": TYPE.ika, "weight": 0.15},
	{"item": TYPE.gold_tako, "weight": 0.05},
	]


onready var takoSprite = $TakoSprite
onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer
onready var emote = $Emotes
onready var hurtBox = $Hurtbox/CollisionShape2D
onready var sfxPlayer = $BonkSFX
onready var popSFX = $PopOut

var state = STATE.DOWN
var bonked = false
var probClass: WeightedRandom
var score = 100.0

var bonkScore = 100
var missScore = -25
var timeUp = [0.8, 1.5]

func _ready() -> void:
	randomize()
	probClass = WeightedRandom.new(probStates)
	takoSprite.animationTree.active = false
	animationPlayer.play("default")
	timer.wait_time = rand_range(1,9)
	
	var newState = probClass.random_pick()
	takoSprite.sprite = newState.name
	bonkScore = newState.bonk
	missScore = newState.miss
	
	timer.start()


func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	timer.stop()
	emit_signal("bonked", bonkScore)
	sfxPlayer.play()
	hurtBox.set_deferred("disabled", true)
	bonked = true
	showEmote()
	animationPlayer.play("down")

func downTako():
	state = STATE.DOWN
	timer.wait_time = rand_range(4,10)
	timer.start()
	
	var newState = probClass.random_pick()
	takoSprite.sprite = newState.name
	bonkScore = newState.bonk
	missScore = newState.miss
	
	timeUp = newState.timeUp
	
	bonked = false


func showEmote():
	var emoteSign: int
	match bonked:
		true:
			emoteSign = emote.EMOTES.circle if bonkScore > 0 else emote.EMOTES.cross
			if takoSprite.sprite == "gold_tako":
				emoteSign = emote.EMOTES.star
		false:
			emoteSign = emote.EMOTES.circle if missScore > 0 else emote.EMOTES.cross
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
			if bonkScore > 0:
				popSFX.play()
			state = STATE.UP
			timer.wait_time = rand_range(timeUp[0], timeUp[1])
			timer.start()



