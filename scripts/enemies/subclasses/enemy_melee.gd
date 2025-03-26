extends Enemy
class_name MeleeEnemy

@export var attack_damage: int = 20
@export var attack_cooldown: float = 1.5  # Time between attacks

var can_attack = true

func attack():
	if not can_attack:
		return
	
	can_attack = false
	print("Melee enemy attacks!")
	
	# Simulate attack hitbox
	for body in attack_area.get_overlapping_bodies():
		if body is Player:  # Ensure we only damage the player
			body.take_damage(attack_damage)

	# Reset attack cooldown
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
