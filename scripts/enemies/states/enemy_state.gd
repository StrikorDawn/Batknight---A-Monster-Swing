extends Node
class_name EnemyState

# This variable will hold the enemy instance when a state is active.
var enemy = null

# Called when the state is entered.
func enter_state(enemy_instance):
	enemy = enemy_instance

# Called when the state is exited.
func exit_state():
	# Perform any necessary cleanup here.
	pass

# Called every frame (non-physics).
func process(delta: float) -> void:
	pass

# Called every physics frame.
func physics_process(delta: float) -> void:
	pass
