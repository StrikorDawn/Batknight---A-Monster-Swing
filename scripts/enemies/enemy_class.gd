extends CharacterBody2D
class_name EnemyClass

######################################
# Custom Signals & Core Variables
######################################
signal enemy_defeated

# Core Attributes – these are set using our setter methods
var health: float
var max_health: float
var move_speed: float
var damage: float
var attack_cooldown: float
var gravity: float = 1000.0  # Standard gravity; for agile enemies you might add jump/fall physics later
var loot_drop: int = 0

# For future agile enemy support, you might add these later:
# @export var jump_height: float = 200.0
# @export var jump_time_to_peak: float = 0.5
# @export var jump_time_to_descent: float = 0.7

# State machine variables
var states = {}  # Dictionary to hold state objects
var current_state = null

# Node references
var animated_sprite: AnimatedSprite2D
var invincibility_timer: Timer

# Invincibility flag
var invincible: bool = false

######################################
# Initialization
######################################
func _ready():
	add_to_group("Enemy")
	
	# Set up node references (assumes an AnimatedSprite2D child exists)
	animated_sprite = $AnimatedSprite2D
	
	# Create and configure the invincibility timer
	invincibility_timer = Timer.new()
	invincibility_timer.one_shot = true
	invincibility_timer.connect("timeout", _on_invincibility_timeout)
	add_child(invincibility_timer)
	
	# Instantiate state objects and store them in a dictionary
	states["Idle"]    = preload("res://scripts/enemies/states/idle_state.gd").new()
	states["Alert"]   = preload("res://scripts/enemies/states/alert_state.gd").new()
	states["Chasing"] = preload("res://scripts/enemies/states/chasing_state.gd").new()
	states["Attack"]  = preload("res://scripts/enemies/states/attack_state.gd").new()
	
	# Assign this enemy instance to each state (like your player setup)
	for state in states.values():
		state.enemy = self
	
	# Set default randomized attributes (subclasses can override these later)
	set_health(100, 20)           # Base health of 100 with ±20 variance
	set_move_speed(50, 10)        # Base move speed of 50 with ±10 variance
	set_damage(10, 3)             # Base damage of 10 with ±3 variance
	set_attack_cooldown(1.5, 0.5)   # Base attack cooldown of 1.5 sec with ±0.5 sec variance
	
	# Start in the Idle state
	change_state("Idle")

######################################
# State Management
######################################
func change_state(new_state_name: String):
	if current_state:
		current_state.exit_state()
	current_state = states[new_state_name]
	current_state.enter_state(self)

######################################
# Physics & Process
######################################
func _physics_process(delta: float) -> void:
	if is_alive():
		# Let the current state handle physics-related behavior
		if current_state:
			current_state.physics_process(delta)
		
		# Apply common physics: update velocity with gravity
		velocity.y += gravity * delta
		
		# move_and_slide() in Godot 4 automatically uses the built-in velocity property
		move_and_slide()
		
		# Handle common animations (or delegate to states)
		handle_animation()

func _process(delta: float) -> void:
	if is_alive() and current_state:
		current_state.process(delta)

######################################
# Combat & Utility Methods
######################################
func take_damage(amount: float) -> void:
	if is_alive() and not invincible:
		health -= amount
		health = max(health, 0)
		if health <= 0:
			die()
		else:
			invincible = true
			invincibility_timer.start(1.0)  # Adjust invincibility duration as needed

func die() -> void:
	emit_signal("enemy_defeated")
	queue_free()

func handle_animation() -> void:
	# Implement common animation handling here or delegate to states
	pass

func is_alive() -> bool:
	return health > 0

func _on_invincibility_timeout() -> void:
	invincible = false

######################################
# Setter Methods with Randomization Support
######################################
func set_health(base_value: float, variance: float = 0.0) -> void:
	max_health = max(base_value + randf_range(-variance, variance), 1)
	health = max_health

func set_move_speed(base_value: float, variance: float = 0.0) -> void:
	move_speed = max(base_value + randf_range(-variance, variance), 0)

func set_damage(base_value: float, variance: float = 0.0) -> void:
	damage = max(base_value + randf_range(-variance, variance), 0)

func set_attack_cooldown(base_value: float, variance: float = 0.0) -> void:
	attack_cooldown = max(base_value + randf_range(-variance, variance), 0.1)
