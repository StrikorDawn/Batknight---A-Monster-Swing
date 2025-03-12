extends EnemyState
class_name IdleState

func enter_state(enemy_instance):
	super.enter_state(enemy_instance)
	# Start idle animation or set idle-specific variables
	if enemy.animated_sprite:
		enemy.animated_sprite.play("idle")

func process(delta: float) -> void:
	# Example: Check for player detection here and then change state:
	# if enemy.detect_player():
	#     enemy.change_state("Alert")
	pass

func physics_process(delta: float) -> void:
	# Idle state might not alter movement physics beyond gravity.
	pass

func exit_state():
	# Clean up when leaving idle state if necessary.
	pass
