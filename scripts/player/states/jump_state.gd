extends PlayerState
class_name JumpState

@export var min_jump_time: float = 0.1  # Minimum time the player must rise before cutting the jump
var jump_timer: float = 0.0  # Track time since jump started

# Sets Jump state entry conditions
func enter_state() -> void:
	# Allow jump if jump_buffer or coyote_time was active
	if player.jump_buffer or player.jump_available or player.is_on_floor():
		player.velocity.y = player.jump_velocity
		player.sprite_2d.play("jump")
		player.is_jumping = true
		jump_timer = 0.0  # Reset timer

		# Reset jump buffer and coyote time since jump has now been performed
		player.jump_buffer = false
		player.jump_available = false

func do_physics_process(delta: float) -> void:
	jump_timer += delta  # Track jump duration
	
	direction = set_direction()
	handle_movement(player.move_speed)
	
	# Jump Cut - Reduces velocity only after the min jump time has passed
	if not Input.is_action_pressed("jump") and jump_timer > min_jump_time:
		player.velocity.y = player.velocity.y * 0.5

	# Apply gravity naturally
	player.velocity.y += player.jump_gravity * delta
	
	# If the player starts falling, transition to FallState
	if player.velocity.y > 0:
		player.jump_available = false
		player.set_state(player.states["Fall"])

	if Input.is_action_just_pressed("dash") and player.dash_available == true:
		player.set_state(player.states["Dash"])
