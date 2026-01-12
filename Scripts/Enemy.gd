extends CharacterBody2D
@export var ignoreme : CollisionShape2D
@export var DamageRate : int
@onready var target = get_node("/root/Node2D/Player")
var speed = 150
var enemyColliding : bool 

var Charvelocity = Vector2.ZERO

var health = 100

enum{
	IDLE,
	CHASE,
	ATTACK,
	HIT
}
var state = CHASE

func TakeDamage(damage: float):
	health -= damage
	if health <= 0:
		process_mode = Node.PROCESS_MODE_DISABLED
		visible = false
		
func Move(Target,delta):
	var direction = (Target.position - global_position).normalized()
	var desired_velocity = direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	look_at(target.position)
	move_and_slide()

func _physics_process(delta: float) -> void:
	#var direction=(target.position - position).normalized()
	#velocity = direction * speed
	#look_at(target.position)
	#move_and_slide()
	
	match state:
		CHASE:
			Move(target,delta)
	
	if enemyColliding:
		target.TakeDamage(DamageRate * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("Entered:", body.name)
	if body.is_in_group("player"):
		print("hit player")
		enemyColliding = true
	else:
		enemyColliding = false
