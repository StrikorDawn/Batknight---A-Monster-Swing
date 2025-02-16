extends RigidBody2D

# Custom Signals
signal bat_grabbed

# Node References
@onready var bat: RigidBody2D = $"."
@onready var spin_timer: Timer = $SpinTimer

# Bat Movement Variables
@export var forward_velocity : int = 750
@export var upward_velocity : int = -250
@export var spin : float = 1000.0

# Bat Check Variables
var is_spinning : bool
var throw_direction : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mass = 0.94
	is_spinning = true
	spin_timer.start()
	throw_bat_logic()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if is_spinning == true:
		apply_torque_impulse(spin)

# Function to apply force to the bat
func throw_bat_logic() -> void:
	if throw_direction == true:
		forward_velocity == abs(forward_velocity)
		spin = abs(spin)
	elif throw_direction == false:
		forward_velocity *= -1
		spin = spin * -1
	apply_impulse(Vector2(forward_velocity, upward_velocity))

func _on_spin_timer_timeout() -> void:
	is_spinning = false



func _on_grab_area_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		bat_grabbed.emit()
		queue_free()
