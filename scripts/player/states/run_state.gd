extends PlayerState
class_name RunState

# Sets Run state entry conditions
func enter_state() -> void:
	if direction:
		player.sprite_2d.play("run")
	else:
		player.sprite_2d.play("idle")
func do_physics_process(_delta: float) -> void:
	var direction = set_direction()
	handle_movement(direction, player.move_speed)
	if direction:
		player.sprite_2d.play("run")
	else:
		player.sprite_2d.play("idle")
	
	if not player.is_on_floor():
		player.set_state(player.states["Fall"])
	
	elif Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.set_state(player.states["Jump"])
	
	elif Input.is_action_just_pressed("dash") and player.dash_available == true:
			player.set_state(player.states["Dash"])
	
	elif not direction:
		player.set_state(player.states["Idle"])
