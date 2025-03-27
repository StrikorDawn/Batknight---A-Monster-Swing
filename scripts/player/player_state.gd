extends Node
class_name PlayerState  # This makes it a globally recognized class

# Allows us to acces the Player attributes
var player: Player
var direction

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

# This is used to set the direction fo the sprite based on player movemnt
func set_direction():
	direction = Input.get_axis("left", "right")
	if direction:
		player.sprite_2d.flip_h = direction < 0
	
	return direction

# This function is used to handle basic movements accross different states
func handle_movement(direction, move_speed):
	if direction:
		player.velocity.x = direction * move_speed # Will move the player forward based on direction.
	else:
		player.velocity.x = 0 # Allows the player to stop while in the air
