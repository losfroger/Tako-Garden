extends Area2D

onready var timer = $Timer

func _ready() -> void:
	timer.wait_time = rand_range(3, 5)
	timer.start()


func _on_Coin_body_entered(_body: Node) -> void:
	queue_free()


func _on_Timer_timeout() -> void:
	queue_free()
