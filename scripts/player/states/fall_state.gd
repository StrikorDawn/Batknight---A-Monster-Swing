extends PlayerState
class_name FallState

# Sets Fall state entry conditions
func enter_state():
	player.is_jumping = true
	player.sprite_2d.play("fall")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func do_physics_process(delta: float) -> void:
	var direction = set_direction()
	# Apply fall gravity
	if not player.is_on_floor():
		player.velocity.y += player.fall_gravity * delta  # Apply fall gravity
		
		# Jump is allowed if within coyote time
		if player.jump_available and Input.is_action_just_pressed("jump"):
			player.set_state(player.states["Jump"])
		
		# Jump buffer: If the player presses jump mid-air, store the intent
		if Input.is_action_just_pressed("jump"):
			player.start_jump_buffer()
	else:
		# Check if jump buffer is active when landing
		if player.jump_buffer:
			player.set_state(player.states["Jump"])
		# Check if Player is moving when landing
		elif direction:
			player.set_state(player.states["Run"])
		# Set player to Idle when Landed
		else:
			player.set_state(player.states["Idle"])
