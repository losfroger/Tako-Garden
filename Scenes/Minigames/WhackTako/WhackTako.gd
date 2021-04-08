extends Node2D

onready var playerHammer = $PlayerHammer
onready var initalCountDown = $UI/InitialCountDown
onready var retryDialog = $UI/RetryDialog
onready var bonkTimeSFX = $BonkTime

onready var takoContainer = $Takos
onready var moreTime = $MoreTime

onready var timeLabel = $UI/CountDownTimer
onready var scoreLabel = $UI/Score
onready var gameOverScreen = $UI/GameOverScreen
onready var blurRect = $UI/BlurScreen
onready var gitGudSFX = $GitGud
onready var pauseMenu = $UI/PauseMenu

enum TYPE {
	TAKO,
	IKA,
}

var probStates = [
	{"item": TYPE.TAKO, "weight": 1.0},
	{"item": TYPE.IKA, "weight": 0.02},
	]


# TODO: Change speed when gaining more points so the takos are
# harder to hit
func _ready() -> void:
	# Setup the initial screen
	get_tree().paused = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	randomize()
	for tako in takoContainer.get_children():
		tako.connect("bonked", scoreLabel, "addScore")
		tako.connect("missed", scoreLabel, "addScore")
	moreTime.connect("bonked_more_time", self, "add_time")
	
	# Wait a little bit so the sprites look correct
	yield(get_tree().create_timer(0.02), "timeout")
	get_tree().paused = true
	
	# Wait for the loading transition to finish
	yield(TransitionScreen, "transition_complete")
	initalCountDown.start()
	yield(initalCountDown, "end_timer")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	playerHammer.visible = true
	playerHammer.global_position = get_global_mouse_position()
	bonkTimeSFX.play()


func add_time() -> void:
	timeLabel.seconds += 10


func _on_CountDownTimer_end_timer() -> void:
	gitGudSFX.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	gameOverScreen.score(scoreLabel.score)
	gameOverScreen.visible = true
	
	blurRect.show()


func _unhandled_input(event: InputEvent) -> void:
	if event.get_action_strength("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pauseMenu.show()
		pauseMenu.mouseMode = Input.MOUSE_MODE_HIDDEN
		get_tree().paused = true
	if event.get_action_strength("fast_reset"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		retryDialog.popup()


func _on_RetryDialog_popup_hide() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
