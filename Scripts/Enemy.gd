extends CharacterBody2D
@export var ignoreme : CollisionShape2D
@export var DamageRate : int
@export var Raycast : RayCast2D
@onready var target #= get_node("/root/Node2D/Player")
@onready var point = get_node("/root/Node2D/Player")
var speed = 150
var enemyColliding : bool 

var Charvelocity = Vector2.ZERO

var faceDire : Vector2

var health = 100

enum{
	PATROL,
	CHASE,
	ATTACK,
	HIT
}
var state = PATROL

func _ready() -> void:
	faceDire = Vector2(-1,-1)
	scale = faceDire

func TakeDamage(damage: float):
	health -= damage
	if health <= 0:
		process_mode = Node.PROCESS_MODE_DISABLED
		visible = false
		
func Patrol(delta):
	velocity.x = lerp(velocity.x, 0.0 * speed, delta * 5)
	if Raycast.is_colliding():
		var collider = Raycast.get_collider()
		if collider.is_in_group("player"):
			target = collider
			state = CHASE
		else:
			state = PATROL
	else:
		state = PATROL
		
func Move(Target,delta):
	if Raycast.is_colliding():
		var collider = Raycast.get_collider()
		if collider.is_in_group("player"):
			var dir_x = sign(Target.position.x - global_position.x)
			velocity.x = lerp(velocity.x, dir_x * speed, delta * 5)
		else:
			state = PATROL
	else:
		state = PATROL

func _physics_process(delta: float) -> void:	
	print (state)
	match state:
		PATROL:
			Patrol(delta)
		CHASE:
			Move(target,delta)
	
	if enemyColliding:
		target.TakeDamage(DamageRate * delta)
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("Entered:", body.name)
	if body.is_in_group("player"):
		print("hit player")
		enemyColliding = true
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("hit player")
		enemyColliding = false
