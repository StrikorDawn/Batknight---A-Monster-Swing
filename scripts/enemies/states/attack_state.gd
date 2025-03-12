extends EnemyState
class_name AttackState

func enter_state(enemy_instance):
	super.enter_state(enemy_instance)
	if enemy.animated_sprite:
		enemy.animated_sprite.play("attack")
	# Optionally trigger attack logic here (e.g., damaging the player, spawning projectiles)

func process(delta: float) -> void:
	# After the attack animation or cooldown, return to chasing or idle.
	if enemy.animated_sprite and enemy.animated_sprite.animation == "attack" and enemy.animated_sprite.is_animation_finished():
		enemy.change_state("Chasing")

func physics_process(delta: float) -> void:
	# Halt movement or add a lunge effect during attack.
	enemy.velocity = Vector2.ZERO

func exit_state():
	pass
