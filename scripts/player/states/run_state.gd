extends PlayerState
class_name RunState

# Sets Run state entry conditions
func enter_state() -> void:
	if player.velocity.x != 0: # Ensures no idle to running visual bugs occur
		player.sprite_2d.play("run")

func do_physics_process(_delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	
	if direction and player.is_on_floor():
		player.velocity.x = direction * player.move_speed
		player.sprite_2d.play("run")
		player.sprite_2d.flip_h = direction < 0  # Flip sprite based on movement
		
	elif not player.is_on_floor(): # Makes Player fall if they are not touching the ground
		player.set_state(player.states["Fall"])
		
	elif direction == 0: # Makes sure that we don't have any running in place bugs
		player.set_state(player.states["Idle"])
		
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.set_state(player.states["Jump"])
	
