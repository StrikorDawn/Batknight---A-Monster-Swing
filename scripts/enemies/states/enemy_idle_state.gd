extends EnemyState
class_name EnemyIdleState

######################################
# Enemy Idle State
######################################
func enter_state(enemy_instance):
	super.enter_state(enemy_instance)
	# Set idle animation and reset movement.
	if enemy.animated_sprite:
		enemy.animated_sprite.play("idle")
	enemy.velocity = Vector2.ZERO

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
