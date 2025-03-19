extends PlayerState
class_name DashState

func enter_state() -> void:
	player.is_dashing = true
	player.dash_available = false
	#player.sprite_2d.play("dash")
	player.dash_timer.start()
		

func do_physics_process(_delta: float) -> void:
	direction = set_direction()
	handle_movement(player.dash_speed)
	
	if not player.is_dashing:
		if not player.is_on_floor():
			player.set_state(player.states["Fall"])
		elif player.is_on_floor() and direction:
			player.set_state(player.states["Run"])
		elif player.is_on_floor() and player.velocity.x == 0:
			player.set_state(player.states["Idle"])

func exit_state():
	player.dash_cool_down.start()
	
