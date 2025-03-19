extends Node
class_name EnemyState

######################################
# Enemy Class Reference
######################################
var enemy : EnemyClass = null

######################################
# State Entry
######################################
func enter_state(enemy_instance):
	enemy = enemy_instance

######################################
# Physics Process (every physics frame)
######################################
func do_physics_process(_delta: float) -> void:
	pass

######################################
# State Exit
######################################
func exit_state():
	# Cleanup if necessary.
	pass
