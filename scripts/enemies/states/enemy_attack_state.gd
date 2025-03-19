extends EnemyState
class_name EnemyAttackState

######################################
# Enemy Attack State
######################################
func enter_state(enemy_instance):
	super.enter_state(enemy_instance)
	# Set attack animation.
	if enemy.animated_sprite:
		enemy.animated_sprite.play("attack")
	# Trigger the attack action (projectile launching, melee hit, etc.).
	enemy.attack()

######################################
# Physics Process (every physics frame)
######################################
func do_physics_process(_delta: float) -> void:
	# Typically, enemy stops moving during an attack.
	enemy.velocity = Vector2.ZERO


######################################
# State Exit
######################################
func exit_state():
	# Cleanup if necessary.
	pass
