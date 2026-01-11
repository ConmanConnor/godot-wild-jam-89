extends CharacterBody2D

@onready var bullet = preload("res://Scenes/Prefabs(Kinda)/Bullet.tscn")

const SPEED = 300.0
const DASHSPEED = 600.0
const DASH_TIME = 0.16
const JUMP_VELOCITY = -400.0

var canDash = true
var isDash = false
var dashDire = Vector2.RIGHT
var dashTime = 0.0

@export var meleeBox : Area2D
var forward = 0
@export var sprite : Sprite2D

var maxHealth = 100
var health = 100

@export var collisionShape : CollisionShape2D

func _ready() -> void:
	meleeBox.visible = false

func dashLogic(delta : float) -> void:
	
	var inputDire: Vector2 = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()
	
	if inputDire.x != 0:
		dashDire.x = inputDire.x
	
	if canDash and Input.is_action_just_pressed("Dash"):
		var final_dash_dire: Vector2 = dashDire
		if inputDire.y != 0 and inputDire.x == 0:
			final_dash_dire.x = 0
		final_dash_dire.y = inputDire.y
		canDash = false
		isDash = true
		dashTime = DASH_TIME
		
		velocity = final_dash_dire * DASHSPEED
	if isDash:
		dashTime -= delta
		if dashTime <= 0.0:
			isDash = false
	
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
	dashLogic(delta)
	if isDash:
		move_and_slide()
		return
	# Add the gravity && add dash logic.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if !isDash and !canDash:
			canDash = true
	else:
		if !isDash and !canDash:
			canDash = true

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
	
	if Input.is_action_just_pressed("Crouch"):
		collisionShape.scale.y = 2
	if Input.is_action_just_released("Crouch"):
		collisionShape.scale.y = 3.5
	
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
