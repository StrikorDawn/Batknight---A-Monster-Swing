extends EnemyState
class_name EnemyChaseState

######################################
# Enemy Chasing State
######################################
func enter_state(enemy_instance):
	super.enter_state(enemy_instance)
	# Set chasing (walking) animation.
	if enemy.animated_sprite:
		enemy.animated_sprite.play("walk")

######################################
# Physics Process (every physics frame)
######################################
func do_physics_process(_delta: float) -> void:
		# Move toward the player.
	var players = enemy.get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		var player = players[0]
		var direction = (player.global_position - enemy.global_position).normalized()
		enemy.velocity = direction * enemy.move_speed
	else:
		enemy.velocity = Vector2.ZERO

######################################
# State Exit
######################################
func exit_state():
	# Cleanup if necessary.
	pass
