extends RigidBody2D
var force = Vector2()

var original_position = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(self.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#apply_force()
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.transform.origin.x = original_position.x
	state.transform.origin.y = original_position.y
	
