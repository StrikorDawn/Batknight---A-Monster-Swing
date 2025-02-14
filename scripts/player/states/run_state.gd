extends PlayerState
class_name RunState

# Sets Run state entry conditions
func enter_state() -> void:
		player.sprite_2d.play("run")

func do_physics_process(_delta: float) -> void:
	var direction = set_direction()
	player.sprite_2d.play("run")
	
	if not player.is_on_floor():
		player.set_state(player.states["Fall"])
	
	elif Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.set_state(player.states["Jump"])
	
	elif not direction:
		player.set_state(player.states["Idle"])
	
