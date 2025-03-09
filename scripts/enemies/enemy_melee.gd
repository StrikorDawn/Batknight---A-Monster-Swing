extends EnemyClass  # Inherit from EnemyClass
class_name MeleeEnemy  # Name this class "MeleeEnemy"
######################################
# Node References
######################################
@onready var animation = $CollisionShape2D/AnimatedSprite2D

######################################
# Melee-specific variables
######################################

func _ready():
	super._ready()
	set_health(50)
	set_move_speed(200)
	set_damage(10)
	set_animated_sprite(animation)


# Custom movement logic to move toward the player
#func do_move(delta: float):
	#if is_alive:
		#direction = (player.position - position).normalized()
		#velocity = direction * 100  # Move towards the player at a fixed speed

# Handle attacking logic
func attack(target: Node):
	if is_alive:
		target.take_damage(damage)  # Apply damage to the player
		print("Melee attack performed!")  # For debugging purposes

# Override animation handling for melee-specific animations
func handle_animation():
	if velocity.x > 0:
		animation.flip_h = false
		animation.play("walk")
	elif velocity.x < 0:
		animation.flip_h = true
		animation.play("walk")
	elif is_hit == true:
		animation.play("hurt")
		await animation.animation_finished
		is_hit = false
	else:
		animation.play("idle")
