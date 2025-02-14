extends RigidBody2D
@onready var bat: RigidBody2D = $"."
@export var forward_velocity : int = 50
@export var upward_velocity : int = -10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass
	
