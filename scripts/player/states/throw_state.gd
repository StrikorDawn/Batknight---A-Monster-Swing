extends PlayerState
class_name ThrowState

func enter_state() -> void:
	player.sprite_2d.play("throw")
	player.throw()
	player.sprite_2d.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)

func _on_animation_finished() -> void:
	player.set_state(player.states["Idle"])  # Return to idle after animation ends
