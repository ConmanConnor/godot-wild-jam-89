extends CharacterBody2D

@onready var target = get_node("/root/Node2D/Player")
var speed = 150

func _physics_process(delta: float) -> void:
	var direction=(target.position - position).normalized()
	velocity = direction * speed
	look_at(target.position)
	move_and_slide()

func _on_Area2d_body_entered(body):
	if body.is_in_group("player"):
		print("hit player")
		target.health -= 10
