extends CharacterBody2D
class_name EnemyBase

######################################
# Node References
######################################


######################################
# Enemy Variables
######################################
var max_health : int
var current_health : int
var attack_damage : int
var move_speed : int
var direction : int
var attack_buffer : float

const GRAVITY : int = 1000
var player_position : Vector2 = Vector2.ZERO
var target : Node2D = null
######################################
# Enemy Flags
######################################
var is_facing_left : bool = true
var can_attack : bool = true
var is_attacking : bool = false
var is_dead : bool = false
var is_player_detected : bool = false

######################################
# Movement Functions
######################################
func _ready():
	add_to_group("Enemy")
	current_health = max_health

func _physics_process(delta):
	if not is_dead:
		apply_gravity(delta)
		handle_animation()
		_update_direction()
		do_move()
	else:
		handle_death()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta  # Apply gravity each frame
		
func do_move():
	pass

func _update_direction():
	if velocity.x > 0:
		direction = 1
		is_facing_left = false
	elif velocity.x < 0:
		direction = -1
		is_facing_left = true

######################################
# Handle Animations
######################################
func handle_animation():
	pass


######################################
# Combat Functions
######################################
func take_damage(damage : int):
	current_health -= damage
	if current_health <= 0: 
		current_health = 0
		is_dead = true

func detect_player():
	pass

func do_attack():
	pass

######################################
# Attack Cooldown Management
######################################
func handle_attack_cooldown():
	pass

######################################
# Death Functions
######################################
func handle_death():
	if is_dead:
		queue_free()

func drop_loot():
	pass
