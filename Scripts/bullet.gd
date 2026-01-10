extends Area2D

var speed : float = 300
var direction = 0

@export var damageDealt : int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * direction * delta
	
	if direction == 0:
		direction = 1
	
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("hit enemy")
		body.TakeDamage(damageDealt)
		process_mode = Node.PROCESS_MODE_DISABLED
		visible = false
