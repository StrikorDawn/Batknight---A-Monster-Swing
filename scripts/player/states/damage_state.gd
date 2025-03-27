extends PlayerState
class_name DamageState

var recovery_time : float = 0.2  # Increased from 0.5 to 0.7 for more impact

func enter_state() -> void:
	player.recovery_timer.timeout.connect(on_recovery_timeout)
	# Play hurt animation if available
	player.sprite_2d.play("hurt")
	# Start a timer for recovery
	player.recovery_timer.start(recovery_time)
	# Return to appropriate state

func on_recovery_timeout():
	player.recovery_timer.timeout.disconnect(on_recovery_timeout)

	if not player.is_on_floor():
		player.set_state(player.states["Fall"])
	elif abs(player.velocity.x) > 0:  # If the player is moving, go to Run instead of Idle
		player.set_state(player.states["Run"])
	else:
		player.set_state(player.states["Idle"])
