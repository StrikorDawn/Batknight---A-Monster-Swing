extends CharacterBody2D
class_name Player

######################################
# Custom Signals
######################################
signal bat_thrown
signal game_over
######################################
# Preloaded Scenes
######################################
const BAT = preload("res://scenes/bat/bat.tscn")

######################################
# Node References
######################################
@onready var sprite_2d: AnimatedSprite2D = $CollisionShape2D/Sprite2D
@onready var jump_buffer_timer: Timer = $Jump/JumpBufferTimer
@onready var coyote_timer: Timer = $Jump/CoyoteTimer
@onready var dash_timer: Timer = $Dash/DashTimer
@onready var dash_cool_down: Timer = $Dash/DashCoolDown
@onready var bat_spawn_point: Marker2D = %BatSpawnPoint
@onready var recovery_timer : Timer = $RecoveryTimer
@onready var attack_area = $BatSpawnPoint/AttackArea
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar

######################################
# Custom Player Gravity Calculations
######################################
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

######################################
# Player Movment Variables
######################################
@export var current_health : int = 100
@export var max_health : int = 100
@export var move_speed : int = 275
@export var dash_speed : int = 1000
@export var jump_height: float = 125
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.4
@export var coyote_time: float = 0.15
@export var jump_buffer_time: float = 0.25
@export var fall_clamp: float = 750

######################################
# Other Player Variables
######################################
var bat_count : int = 1

######################################
# Player Check variables
######################################
var on_floor_now : bool
var was_on_floor : bool
var is_jumping : bool = false
var jump_available : bool = false
var jump_buffer : bool = false
var is_facing_right : bool
var is_dashing : bool
var dash_available : bool = true

######################################
# Player State Variables
######################################
var states = {}
var current_state: PlayerState

func _ready():
	add_to_group("Player")
	attack_area.monitoring = false
	attack_area.visible = false
	
	# Create and store state instances
	states["Idle"] = IdleState.new()
	states["Run"] = RunState.new()
	states["Jump"] = JumpState.new()
	states["Fall"] = FallState.new()
	states["Throw"] = ThrowState.new()
	states["Melee"] = MeleeState.new()
	states["Dash"] = DashState.new()
	states["Damage"] = DamageState.new()
	states["Death"] = DeathState.new()

	# Assign player reference to each state
	for state in states.values():
		state.player = self

	# Connect jump buffer and coyote time timers
	jump_buffer_timer.timeout.connect(on_jump_buffer_timeout)
	coyote_timer.timeout.connect(on_coyote_timeout)
	
	# Set initial state
	set_state(states["Idle"])
	health_bar.update(max_health, current_health)

######################################
# Calls Physics Code
######################################
func _physics_process(delta):
	if Input.is_action_just_pressed("left"):
		is_facing_right = false
		bat_spawn_point.position.x = -56
	elif Input.is_action_just_pressed("right"):
		bat_spawn_point.position.x = 56
		is_facing_right = true
	
	on_floor_now = is_on_floor() # Marks if player was on floor 
	
	# If we were on the floor but now we are not, start coyote time
	if was_on_floor and not on_floor_now:
		start_coyote_time()	
		
	was_on_floor = on_floor_now  # Update floor tracking
	
	current_state.do_physics_process(delta)
	move_and_slide()  # Handle movement

######################################
# Allows State Transitions
######################################
func set_state(new_state: PlayerState):
	if current_state:
		current_state.exit_state() # Finalizes current state
	current_state = new_state
	current_state.enter_state() # Initiates new state start up

######################################
# Forces DamageState when hit
######################################
func take_damage(amount: int, attaker_position : Vector2):
	var knockback_direction = (global_position - attaker_position).normalized()
	current_health -= amount
	health_bar.update(max_health, current_health) #updates the health bar 
	print(current_health)
	
	if current_health <= 0:
		current_health = 0
		set_state(states["Death"])
	else:
		set_state(states["Damage"])  # Enter damage state
		velocity = Vector2(knockback_direction.x * 400, -50)
		move_and_slide()


######################################
# Allows for non pixel perfect jumps
######################################
func start_coyote_time():
	jump_available = true
	coyote_timer.one_shot = true
	coyote_timer.start(coyote_time)

######################################
# Ensures no infinite jumps
######################################
func on_coyote_timeout():
	jump_available = false
	
######################################
# Allows user to "prep" a jump 
# before they touch the ground
######################################
func start_jump_buffer():
	jump_buffer = true
	jump_buffer_timer.one_shot = true
	jump_buffer_timer.start(jump_buffer_time)

######################################
# Ensures no uninteded jumps occur
######################################
func on_jump_buffer_timeout():
	jump_buffer = false

######################################
# Ensures dash ends
######################################
func _on_dash_timer_timeout():
	is_dashing = false

######################################
# Ensures player cannot spam dash
######################################
func _on_dash_cool_down_timeout() -> void:
	dash_available = true

######################################
# Signals that the player wants to 
# throw a bat
######################################
func throw():
	bat_thrown.emit(bat_spawn_point.global_position, is_facing_right)

######################################
# Allows the game to track the
# the nubmer of bats thrown.
######################################
func get_bat_count() -> int:
	return bat_count

######################################
# Tells the game how many bats
# the player is allowed to throw
######################################
func set_bat_count(bat_number : int):
	bat_count += bat_number
