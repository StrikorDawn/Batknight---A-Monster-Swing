extends PlayerState
class_name  DeathState

func enter_state() -> void:
	player.velocity = Vector2.ZERO
	player.sprite_2d.play("death")
	await player.sprite_2d.animation_finished
	player.queue_free()
	player.game_over.emit()
