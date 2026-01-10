extends CharacterBody2D

@onready var bullet = preload("res://Scenes/Prefabs(Kinda)/Bullet.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var meleeBox : Area2D
var forward = 0
@export var sprite : Sprite2D

var maxHealth = 100
var health = 100



func _ready() -> void:
	meleeBox.visible = false
	
func TakeDamage(damage: float):
	health -= damage
	if health <= 0:
		#print("Player died")
		process_mode = Node.PROCESS_MODE_DISABLED
		visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_left"):
		forward = -1
		sprite.scale.x = -1
	if Input.is_action_just_pressed("ui_right"):
		forward = 1
		sprite.scale.x = 1
	
		

func _physics_process(delta: float) -> void:
	#print(health)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var Playerdirection := Input.get_axis("ui_left", "ui_right")
	if Playerdirection:
		velocity.x = Playerdirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("Shoot"):
		var bullet_temp = bullet.instantiate()
		bullet_temp.direction = forward
		bullet_temp.position = position 
		get_tree().root.add_child(bullet_temp)
		
	if Input.is_action_just_pressed("Melee"):
		meleeBox.visible = true
		meleeBox.Attacking = true
		$Timer.start()


func _on_timer_timeout() -> void:
	meleeBox.visible = false
	meleeBox.Attacking = false
