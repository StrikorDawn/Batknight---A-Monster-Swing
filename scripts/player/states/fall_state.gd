extends PlayerState
class_name FallState

# Sets Fall state entry conditions
func enter_state():
	player.is_jumping = true
	player.sprite_2d.play("fall")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func do_physics_process(delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	if direction:
		player.velocity.x = direction * player.move_speed  # Maintain control in air
		player.sprite_2d.flip_h = direction < 0
	else:
		player.velocity.x = 0 # Allows the player to stop arial momentum
		
	if not player.is_on_floor():
		player.velocity.y += player.fall_gravity * delta  # Apply fall gravity
		
		# Jump is allowed if within coyote time
		if player.jump_available and Input.is_action_just_pressed("jump"):
			player.set_state(player.states["Jump"])
		
	elif direction:
		player.set_state(player.states["Run"])
	else:
		player.set_state(player.states["Idle"])
