extends CharacterBody2D
@export var ignoreme : CollisionShape2D
@export var DamageRate : int
@export var Raycast : RayCast2D
@onready var target 
@onready var colTarg 
var speed = 100
var enemyColliding : bool 

var Charvelocity = Vector2.ZERO

var faceDire : float = 1

var health = 100

enum{
	PATROL,
	CHASE,
	ATTACK,
	HIT
}
var state = PATROL

func TakeDamage(damage: float):
	health -= damage
	if health <= 0:
		process_mode = Node.PROCESS_MODE_DISABLED
		visible = false
		
func Patrol(delta):
	velocity.x = lerp(velocity.x, faceDire * speed, delta * 5)

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
	#print (state)
	match state:
		PATROL:
			Patrol(delta)
		CHASE:
			Move(target,delta)
	

		
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
	
	reverse_dire()
	
	if enemyColliding:
		colTarg.TakeDamage(DamageRate * delta)

func reverse_dire():
	if is_on_wall():
		faceDire = -faceDire
		scale.x = faceDire
		print(faceDire)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("Entered:", body.name)
	if body.is_in_group("player"):
		print("hit player")
		enemyColliding = true
		colTarg = body
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("hit player")
		enemyColliding = false
