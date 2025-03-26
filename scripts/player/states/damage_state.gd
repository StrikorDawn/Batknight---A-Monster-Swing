extends PlayerState
class_name DamageState

var knockback_force := Vector2.ZERO
var recovery_time := 0.4  # Adjust as needed
var invincible_time := 0.6  # Prevent instant re-hits

#func enter_state() -> void:
	#player.velocity = knockback_force  # Apply knockback
	#player.sprite_2d.play("hurt")  # Play damage animation if available
	#player.set_physics_process(false)  # Disable movement temporarily
#
	## Start a timer for recovery
	#await get_tree().create_timer(recovery_time).timeout
	#player.set_physics_process(true)  # Re-enable movement
#
	## Start a brief invincibility window
	#player.set_collision_layer_value(1, false)  # Disable player collision
	#await get_tree().create_timer(invincible_time).timeout
	#player.set_collision_layer_value(1, true)  # Re-enable collision
#
	## Return to the correct state (Idle, Fall, or Run)
	#if not player.is_on_floor():
		#player.set_state(player.states["Fall"])
	#else:
		#player.set_state(player.states["Idle"])

#func take_damage(amount: int, knockback: Vector2):
	#player.health -= amount
	#knockback_force = knockback
