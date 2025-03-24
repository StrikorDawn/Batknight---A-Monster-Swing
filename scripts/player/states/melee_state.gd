extends PlayerState
class_name MeleeState

var has_bat : bool
# Sets Melee state entry conditions
func enter_state() -> void:
	if player.bat_count > 0:
		has_bat = true
	else:
		has_bat = false
		
	player.sprite_2d.play("throw")  # Play melee animation
	player.attack_area.monitoring = true
	player.attack_area.visible = true  # Ensure it's visible for debugging
	player.sprite_2d.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)

func do_physics_process(_delta: float) -> void:
	# Get enemies inside attack area
	var enemies = player.attack_area.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.has_method("take_damage"):  # Ensure the enemy has a damage function
			if has_bat:
				enemy.take_damage(10)  # Deal damage
			else:
				enemy.take_damage(3)

	# Maintain movement if needed
	set_direction()
	handle_movement(direction, player.move_speed)

func _on_animation_finished():
	player.attack_area.monitoring = false
	player.attack_area.visible = false
	if player.velocity.x != 0:
		player.set_state(player.states["Run"])
	else:
		player.set_state(player.states["Idle"])  # Return to idle after animation ends
