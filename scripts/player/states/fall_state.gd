extends PlayerState
class_name FallState

# Sets Fall state entry conditions
func enter_state():
	player.is_jumping = true
	player.sprite_2d.play("fall")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func do_physics_process(delta: float) -> void:
	direction = set_direction()
	handle_movement(direction, player.move_speed)
	# Apply fall gravity
	if not player.is_on_floor():
		# Controls player fall speed over time
		if player.velocity.y < player.fall_clamp:
			player.velocity.y += player.fall_gravity * delta  # Apply fall gravity
		else:
			player.velocity.y = player.fall_clamp
			 
		# If Dash is allowed sets to dash.
		if Input.is_action_just_pressed("dash") and player.dash_available == true:
			player.set_state(player.states["Dash"])
		
		elif Input.is_action_just_pressed("melee"):
			player.set_state(player.states["Melee"])
		
		elif Input.is_action_just_pressed("throw"):
			player.set_state(player.states["Throw"])
		
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
