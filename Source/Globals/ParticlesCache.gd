extends CanvasLayer


var takoHeart = preload("res://Assets/Particles/TakoHearts.tres")

var materials = [
	takoHeart,
]


func _ready():
	for material in materials:
		var particles_instance = Particles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_emitting(true)
		particles_instance.set_modulate(Color(1,1,1,0))
		self.add_child(particles_instance)
