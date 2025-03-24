extends PlayerState
class_name IdleState

# Sets idle state enter conditions
func enter_state() -> void:
	player.sprite_2d.play("idle")
	player.velocity.x = 0

func do_physics_process(_delta: float) -> void:
	# Checks to see if the player is currently in the air
	if not player.is_on_floor(): 
		player.set_state(player.states["Fall"])

	elif Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.set_state(player.states["Jump"])
		
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		player.set_state(player.states["Run"])
		
	elif Input.is_action_just_pressed("throw"):
		player.set_state(player.states["Throw"])
