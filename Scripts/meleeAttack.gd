extends Area2D

@export var damageDealt : int

var Attacking : bool

func _on_body_entered(body: Node2D) -> void:
	print("Has TakeDamage:", body.has_method("TakeDamage"))
	print(Attacking)
	if body.is_in_group("enemy") && Attacking == true:
		print("hit enemy")
		body.TakeDamage(damageDealt)
