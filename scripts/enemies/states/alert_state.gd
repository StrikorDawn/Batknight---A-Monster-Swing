extends EnemyState
class_name AlertState

func enter_state(enemy_instance):
	super.enter_state(enemy_instance)
	if enemy.animated_sprite:
		enemy.animated_sprite.play("alert")

func process(delta: float) -> void:
	# After alerting briefly, decide if the enemy should chase or return to idle.
	# Example:
	# if enemy.confirm_player_presence():
	#     enemy.change_state("Chasing")
	# elif not enemy.detect_player():
	#     enemy.change_state("Idle")
	pass

func physics_process(delta: float) -> void:
	pass

func exit_state():
	pass
