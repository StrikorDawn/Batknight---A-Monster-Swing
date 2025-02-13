extends CharacterBody2D
class_name Player

signal bat_thrown

@onready var sprite_2d: AnimatedSprite2D = $CollisionShape2D/Sprite2D
@onready var jump_buffer_timer: Timer = $"Jump Buffer Timer"
@onready var coyote_timer: Timer = $"Coyote Timer"
@onready var bat_spawn_point: Marker2D = %BatSpawnPoint
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

const BAT = preload("res://scenes/bat.tscn")

@export var move_speed = 275
@export var jump_height: float = 125
@export var jump_time_to_peak: float = .5
@export var jump_time_to_descent: float = 0.4
@export var coyote_time: float = 0.5
@export var jump_buffer_time: float = 1
@export var fall_clamp: float = 100

var is_dying = false
var is_jumping = false
var jump_available: bool = false
var jump_buffer: bool = false

var states = {}
var current_state: PlayerState

func _ready():
	add_to_group("Player")
	
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

func _physics_process(delta):
	current_state.do_physics_process(delta)
	move_and_slide()  # Handle movement

func set_state(new_state: PlayerState):
	if current_state:
		current_state.exit_state()
	current_state = new_state
	current_state.enter_state()

func on_jump_buffer_timeout():
	jump_buffer = false

func on_coyote_timeout():
	print("timeout!!!")
	jump_available = false

func throw():
	bat_thrown.emit(bat_spawn_point.global_position)

func start_jump_buffer():
	jump_buffer = true
	jump_buffer_timer.start(jump_buffer_time)

func start_coyote_time():
	jump_available = true
	coyote_timer.start(coyote_time)
