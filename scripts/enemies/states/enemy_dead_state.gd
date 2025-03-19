extends EnemyState
class_name EnemyDeadState

######################################
# Enemy Dead State
######################################
func enter_state(enemy_instance):
	super.enter_state(enemy_instance)
	# Set death animation.
	if enemy.animated_sprite:
		enemy.animated_sprite.play("death")
	# Disable enemy collisions and movement.
	enemy.velocity = Vector2.ZERO
	enemy.set_collision_layer(0)
	enemy.set_collision_mask(0)

######################################
# Physics Process (every physics frame)
######################################
func do_physics_process(_delta: float) -> void:
	pass

######################################
# State Exit
######################################
func exit_state():
	enemy.enemy_died.emit(enemy.global_position)
	queue_free()
