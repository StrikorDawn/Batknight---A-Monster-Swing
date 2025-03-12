extends EnemyState
class_name ChasingState

func enter_state(enemy_instance):
	super.enter_state(enemy_instance)
	if enemy.animated_sprite:
		enemy.animated_sprite.play("run")

func process(delta: float) -> void:
	# Check if within attack range, then switch to attack state.
	# Example:
	# if enemy.is_in_attack_range():
	#     enemy.change_state("Attack")
	pass

func physics_process(delta: float) -> void:
	# Move toward the player (modify for agile behavior as needed)
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		var player = players[0]
		var direction = (player.global_position - enemy.global_position).normalized()
		enemy.velocity = direction * enemy.move_speed
	else:
		enemy.velocity = Vector2.ZERO

func exit_state():
	pass
