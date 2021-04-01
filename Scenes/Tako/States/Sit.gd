extends TakoState

onready var timer = $Timer

func enter(_msg := {}) -> void:
	tako.takoSprite.animation("rest")
	yield(get_tree().create_timer(0.5), "timeout")
	tako.emoteSprite.emote(tako.emoteSprite.EMOTES.z2, 1.2)
	
	var randomTime = rand_range(10, 30)
	timer.wait_time = randomTime
	timer.start()
	
	tako.searchFoodArea.monitoring = false
	tako.eatFoodArea.monitoring = false
	tako.set_physics_process(false)

func exit():
	tako.searchFoodArea.monitoring = true
	tako.eatFoodArea.monitoring = true
	tako.set_physics_process(true)
	timer.stop()


func _on_Timer_timeout() -> void:
	tako.takoSprite.animation("idle")
	state_machine.transition_to("Idle")
