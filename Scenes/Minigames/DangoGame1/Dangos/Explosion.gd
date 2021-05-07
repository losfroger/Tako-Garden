extends Node2D

onready var particles = [$MainExplosion, $MainExplosion/Sparks, $MainExplosion/Smoke]
onready var sfx = $ExplosionSFX

func _ready() -> void:
	for particle in particles:
		particle.one_shot = true
		particle.emitting = true
	
	#$MainExplosion.emitting = true
	#$MainExplosion/Sparks.emitting = true
	#$MainExplosion/Smoke.emitting = true
	sfx.play()
	yield(get_tree().create_timer(2.0),"timeout")
	queue_free()
