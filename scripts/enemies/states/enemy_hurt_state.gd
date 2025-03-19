extends EnemyState
class_name EnemyHurtState

######################################
# Enemy Hurt State
######################################
var hurt_duration: float = 0.5

func enter_state(enemy_instance):
	super.enter_state(enemy_instance)
	# Set hurt animation.
	if enemy.animated_sprite:
		enemy.animated_sprite.play("hurt")
	# Stop enemy movement.
	enemy.velocity = Vector2.ZERO
	# After hurt duration, return to Idle (or another state as desired).
	enemy.get_tree().create_timer(hurt_duration).connect("timeout", Callable(self, "_on_hurt_timeout"))


func _on_hurt_timeout():
	if enemy.is_alive():
		enemy.change_state("Idle")
