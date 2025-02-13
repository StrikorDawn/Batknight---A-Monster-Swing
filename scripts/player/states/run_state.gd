extends PlayerState
class_name RunState

func enter_state() -> void:
	if Input.is_action_just_pressed("left") and Input.is_action_just_pressed("right"):
		player.sprite_2d.play("idle")
	else:
		player.sprite_2d.play("run")

func do_physics_process(_delta: float) -> void:
	var direction = Input.get_axis("left", "right")
	if direction and player.is_on_floor():
		player.velocity.x = direction * player.move_speed
		player.sprite_2d.play("run")
		player.sprite_2d.flip_h = direction < 0  # Flip sprite based on movement
	elif not Input.is_anything_pressed():
		player.set_state(player.states["Idle"])
	else:
		player.set_state(player.states["Fall"])
		
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.set_state(player.states["Jump"])
	
	
