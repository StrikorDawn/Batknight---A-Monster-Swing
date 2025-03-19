extends CharacterBody2D
class_name EnemyClass

######################################
# Custom Signals
######################################
signal enemy_died

######################################
# Preloaded Scenes
######################################
# (Add any preloaded scenes here if necessary)

######################################
# Node References
######################################
@onready var animated_sprite: AnimatedSprite2D = $CollisionShape2D/AnimatedSprite2D
@onready var invincibility_timer: Timer = $InvincibilityTimer

######################################
# Enemy Attributes
######################################
@export var max_health: float = 100.0
@export var move_speed: float = 100.0
@export var damage: float = 10.0
@export var attack_cooldown: float = 1.5
@export var gravity: float = 1000.0
@export var invincibility_duration: float = 0.75
@export var loot_drop: int = 0

######################################
# Additional Variables
######################################
var health: float = max_health
var invincible: bool = false
var is_hit: bool = false
var is_dead: bool = false

######################################
# State Machine Variables
######################################
var states = {}  # Dictionary to hold state objects
var current_state = null

######################################
# Setter Methods with Randomization Support
######################################
func set_sprite(sprite: AnimatedSprite2D):
	animated_sprite = sprite

func set_health(base_value: float, variance: float = 0.0) -> void:
	max_health = max(base_value + randf_range(-variance, variance), 1)
	health = max_health

func set_move_speed(base_value: float, variance: float = 0.0) -> void:
	move_speed = max(base_value + randf_range(-variance, variance), 0)

func set_damage(base_value: float, variance: float = 0.0) -> void:
	damage = max(base_value + randf_range(-variance, variance), 0)

func set_attack_cooldown(base_value: float, variance: float = 0.0) -> void:
	attack_cooldown = max(base_value + randf_range(-variance, variance), 0.1)

######################################
# Initialization
######################################
func _ready():
	add_to_group("Enemy")
	
	# Connect invincibility timer
	invincibility_timer.timeout.connect(_on_invincibility_timeout)
	
	# Instantiate state objects and store them in a dictionary
	states["Idle"]    = EnemyIdleState.new()
	states["Alert"]   = EnemyAlertState.new()
	states["Chase"]   = EnemyChaseState.new()
	states["Attack"]  = EnemyAttackState.new()
	states["Hurt"]    = EnemyHurtState.new()
	states["Dead"]    = EnemyDeadState.new()
	
	# Assign this enemy instance to each state
	for state in states.values():
		state.enemy = self

	
	# Start in the Idle state
	change_state("Idle")

######################################
# State Management
######################################
func change_state(new_state_name: String):
	if current_state:
		current_state.exit_state()
	current_state = states.get(new_state_name, null)
	if current_state:
		current_state.enter_state(self)

######################################
# Physics & Process
######################################
func _physics_process(delta: float) -> void:
	if is_alive():
		# Let the current state handle physics-related behavior
		if current_state:
			current_state.do_physics_process(delta)
		# Apply common physics: update velocity with gravity
		velocity.y += gravity * delta
		# move_and_slide() in Godot 4 automatically uses the built-in velocity property
		move_and_slide()

######################################
# Combat & Utility Methods
######################################
func take_damage(amount: float) -> void:
	if is_alive() and not invincible:
		is_hit = true
		health -= amount
		health = max(health, 0)
		print(health)
		if health <= 0:
			die()
		else:
			invincible = true
			invincibility_timer.start(invincibility_duration)
			change_state("Hurt")

func die() -> void:
	change_state("Dead")

func is_alive() -> bool:
	return health > 0

######################################
# Timer Callbacks
######################################
func _on_invincibility_timeout() -> void:
	invincible = false
