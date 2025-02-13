extends CharacterBody2D
class_name Player

# Custom Signals
signal bat_thrown

# Preloaded Scenes
const BAT = preload("res://scenes/bat.tscn")

# Node References
@onready var sprite_2d: AnimatedSprite2D = $CollisionShape2D/Sprite2D
@onready var jump_buffer_timer: Timer = $"Jump Buffer Timer"
@onready var coyote_timer: Timer = $"Coyote Timer"
@onready var bat_spawn_point: Marker2D = %BatSpawnPoint

# Custom Player Gravity Calculations
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

# Player Movment Variables
@export var move_speed = 275
@export var jump_height: float = 125
@export var jump_time_to_peak: float = .5
@export var jump_time_to_descent: float = 0.4
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 1.0
#@export var fall_clamp: float = 100

# Player Check variables
var on_floor_now : bool
var was_on_floor : bool
var is_jumping: bool = false
var jump_available: bool = false
var jump_buffer: bool = false

# Player State Variables
var states = {}
var current_state: PlayerState

func _ready():
	#add_to_group("Player")
	
	# Create and store state instances
	states["Idle"] = IdleState.new()
	states["Run"] = RunState.new()
	states["Jump"] = JumpState.new()
	states["Throw"] = ThrowState.new()
	states["Fall"] = FallState.new()

	# Assign player reference to each state
	for state in states.values():
		state.player = self

	# Connect jump buffer and coyote time timers
	jump_buffer_timer.timeout.connect(on_jump_buffer_timeout)
	coyote_timer.timeout.connect(on_coyote_timeout)

	# Set initial state
	set_state(states["Idle"])

# Calls Physics Code
func _physics_process(delta):
	on_floor_now = is_on_floor() # Marks if player was on flor 
	
	# If we were on the floor but now we are not, start coyote time
	if was_on_floor and not on_floor_now:
		start_coyote_time()	
		
	was_on_floor = on_floor_now  # Update floor tracking
	
	current_state.do_physics_process(delta)
	move_and_slide()  # Handle movement

# Allows State Transitions
func set_state(new_state: PlayerState):
	if current_state:
		current_state.exit_state() # Finalizes current state
	current_state = new_state
	current_state.enter_state() # Initiates new state start up

# Allows the user to still jump even when the computer registers them as
# not on the ground anymore.
func start_coyote_time():
	jump_available = true
	coyote_timer.one_shot = true
	coyote_timer.start(coyote_time)

# Ensures that no infinite jumps happen
func on_coyote_timeout():
	jump_available = false

# Allows user to "prep" a jump before they touch the ground
func start_jump_buffer():
	jump_buffer = true
	jump_buffer_timer.one_shot = true
	jump_buffer_timer.start(jump_buffer_time)

# Ensures no uninteded jumps occur
func on_jump_buffer_timeout():
	jump_buffer = false

# Signals that the player want's to throw a bat
func throw():
	bat_thrown.emit(bat_spawn_point.global_position)
