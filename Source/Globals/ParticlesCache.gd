# Global class that loads the particles at the start of the game, to not cause stutters later
extends CanvasLayer


var takoHeart = preload("res://Assets/Particles/TakoHearts.tres")
var bomb_sparks = preload("res://Assets/Particles/BombSparks.tres")
var explosion_main = preload("res://Assets/Particles/Explosion/MainExplosion.tres")
var explosion_sparks = preload("res://Assets/Particles/Explosion/Sparks.tres")
var explosion_smoke = preload("res://Assets/Particles/Explosion/Smoke.tres")

var materials = [
	takoHeart,
	explosion_main,
	explosion_sparks,
	explosion_smoke,
]


func _ready():
	for material in materials:
		var particles_instance = Particles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_emitting(true)
		particles_instance.set_modulate(Color(1,1,1,0))
		self.add_child(particles_instance)
