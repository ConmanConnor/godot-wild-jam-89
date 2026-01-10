extends Area2D

@export var damageDealt : int

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("hit enemy")
		body.TakeDamage(damageDealt)
		process_mode = Node.PROCESS_MODE_DISABLED
		visible = false
