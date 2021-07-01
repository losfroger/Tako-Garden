extends Area2D

signal collected(points)

onready var despawnTimer = $DespawnTimer
onready var blinkTimer = $BlinkTimer

onready var blinkTween = $blinkSpeedTween
onready var floatAnim = $FloatAnim
onready var dissappearAnim = $DissappearAnim
onready var glowAnim = $GlowAnim

onready var dangoSprite = $Position2D/GoldDango
onready var glowSprite = $Position2D/GlowSprite
onready var colShape = $CollisionShape2D

onready var collectSFX = $CollectSFX

var points = 250

func _ready() -> void:
	despawnTimer.wait_time = rand_range(8, 10)
	
	blinkTimer.wait_time = despawnTimer.wait_time - 3
	
	despawnTimer.start()
	blinkTimer.start()
	
	floatAnim.play("default")
	floatAnim.play("float")
	glowAnim.play("Glow")


func _on_Coin_body_entered(_body: Node) -> void:
	emit_signal("collected", points)
	
	dangoSprite.visible = false
	glowSprite.visible = false
	
	despawnTimer.stop()
	colShape.set_deferred("disabled", true)
	
	collectSFX.play()
	yield(collectSFX, "finished")
	
	queue_free()


func _on_BlinkTimer_timeout() -> void:
	blinkTween.interpolate_property(dissappearAnim, "playback_speed", 1, 3, 3,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	blinkTween.start()
	dissappearAnim.play("blink")


func _on_DespawnTimer_timeout() -> void:
	queue_free()
