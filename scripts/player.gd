extends CharacterBody2D

signal bat_thrown
@onready var sprite_2d: AnimatedSprite2D = $CollisionShape2D/Sprite2D
@onready var jump_buffer_timer: Timer = $"Jump Buffer Timer"
@onready var coyote_timer: Timer = $"Coyote Timer"
@onready var bat_spawn_point: Marker2D = %BatSpawnPoint

const BAT = preload("res://scenes/bat.tscn")

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var move_speed = 275
@export var jump_height : float = 100
@export var jump_time_to_peak : float = .5
@export var jump_time_to_descent : float = 0.4
@export var coyote_time: float = 0.075
@export var jump_buffer_time: float = 0.15
@export var fall_clamp : float = 100


var is_dying = false
var is_jumping = false
var jump_available: bool = true
var jump_buffer: bool = false

func _ready():
	add_to_group("Player")
	
func _physics_process(delta):
	if is_dying:
		return
	
	# Add the gravity
	velocity.y += set_gravity() * delta
	if not is_on_floor():
		if coyote_timer.is_stopped():
			coyote_timer.start(coyote_time)
			
		if (velocity.y < 0 && Input.is_action_just_released("jump")):
			velocity.y = 0
	else:
		is_jumping = false
		jump_available = true
		coyote_timer.stop()
		if jump_buffer:
			jump()
			jump_buffer = false

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if jump_available:
			jump()
		else:
			jump_buffer = true
			if jump_buffer_timer.is_stopped():
				jump_buffer_timer.start(jump_buffer_time)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("throw"):
		throw()
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
	update_animation(direction)
	move_and_slide()

func update_animation(_direction):
	if velocity.x > 0 and is_on_floor():
		sprite_2d.play("run")
		sprite_2d.flip_h = false
	elif velocity.x < 0 and is_on_floor():
		sprite_2d.play("run")
		sprite_2d.flip_h = true
	elif velocity.x == 0 and is_on_floor():
		sprite_2d.play("idle")
	elif velocity.y < 0:
		sprite_2d.play("jump")
		if Input.is_action_just_pressed("right"):
			sprite_2d.flip_h = false
		elif Input.is_action_just_pressed("left"):
			sprite_2d.flip_h = true
	elif velocity.y > 0:
		sprite_2d.play("fall")
		if Input.is_action_just_pressed("right"):
			sprite_2d.flip_h = false
			bat_spawn_point.global_position.x = 50
		elif Input.is_action_just_pressed("left"):
			sprite_2d.flip_h = true
			bat_spawn_point.global_position.x = -50
		
func set_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
	
func jump():
	velocity.y = jump_velocity
	jump_available = false
	is_jumping = true
	
func on_jump_buffer_timeout():
	jump_buffer = false
	
func coyote_timeout():
	jump_available = false

func throw():
	bat_thrown.emit(bat_spawn_point.global_position)
	
