extends Area2D

export (Array, String) var groups_to_despawn


func _on_DespawnArea_body_entered(body: Node) -> void:
	for group in groups_to_despawn:
		if body.is_in_group(group):
			body.queue_free()
