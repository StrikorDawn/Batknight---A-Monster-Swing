extends Node
class_name PlayerState  # This makes it a globally recognized class

# Allows us to acces the Player attributes
var player: Player

# Allows us to set up State attrubutes and animations for first frame
func enter_state() -> void:
	pass

# Allows us to finalize current state conditions
func exit_state() -> void:
	pass

# Allows us to do physics processes in our subclasses
func do_physics_process(_delta: float) -> void:
	pass

# Not really sure what this does, but will find out if we actually need to use it.
#func do_input(_event: InputEvent) -> void:
	#pass

func set_direction():
	var direction = Input.get_axis("left", "right")
	# Maintain control in air
	if direction:
		player.velocity.x = direction * player.move_speed  
		player.sprite_2d.flip_h = direction < 0
			
	else:
		player.velocity.x = 0 # Allows the player to stop arial momentum
		
	return direction
