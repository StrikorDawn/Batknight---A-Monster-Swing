extends EnemyBase
class_name EnemyMelee

######################################
# Node References
######################################
@onready var sprite = $Sprite
@onready var attack_point = $AttackPoint
@onready var attack_area = $AttackPoint/AttackArea
@onready var detection_area = $"DetectionArea"
@onready var attack_cooldown = $AttackCooldown
@onready var attack_range = $AttackPoint/AttackArea/AttackRange
@onready var damage_cooldown: Timer = $DamageCooldown

######################################
# Enemy Variables
######################################
func _ready():
	max_health = 50
	current_health = max_health
	attack_damage = 20
	move_speed = 100
	attack_buffer = 1.0
	super._ready()
	health_bar.update(max_health,current_health)
	
######################################
# Movement Functions
######################################
func _physics_process(delta):
	if not is_dead:
		# Apply gravity continuously if not on the floor
		if not is_on_floor():
			velocity.y += GRAVITY * delta  # Apply gravity each frame
		_update_direction()
		if is_player_detected and target:
			player_position = target.position
		if is_player_in_attack_range() and can_attack:
			do_attack()
		else:
			do_move()
		handle_animation()
		if sprite.animation == "attack":
			await sprite.animation_finished
			is_attacking = false
	else:
		handle_death()

# Override the do_move() function to move towards the player
func do_move():
	# Only move if the player is detected
	if is_player_detected and not is_player_in_attack_range():
		# Calculate the direction to move towards the player
		_update_direction()
		if not is_attacking:
			velocity.x = direction * move_speed
		else:
			velocity.x = 0
	else:
		# Stop moving if the player is not detected
		velocity.x = 0
	move_and_slide()

# Update direction based on velocity for correct facing
func _update_direction():
	if player_position.x - position.x > 0:
		direction = 1
		is_facing_left = false
		sprite.flip_h = true
		attack_point.rotation_degrees = 180
	elif player_position.x - position.x < 0:
		direction = -1
		is_facing_left = true
		sprite.flip_h = false
		attack_point.rotation_degrees = 0


######################################
# Handle Animations
######################################
func handle_animation():
	if is_player_detected:
		if velocity != Vector2.ZERO and not is_attacking:
			sprite.play("run")  # Play running animation if the player is detected
		elif is_attacking:
			# Only play the attack animation if it's not already playing
			if sprite.animation != "attack":
				sprite.play("attack")
		else:
			sprite.play("idle")
	else:
		sprite.play("idle")

######################################
# Combat Functions
######################################
# Trigger the attack if the player is in range (using RayCast2D for stopping movement and starting the attack)
func do_attack():
	if is_player_in_attack_range() and can_attack:
		# Handle attacking logic here
		can_attack = false
		if attack_area.overlaps_body(target):
			target.take_damage(attack_damage, global_position)
			is_attacking = true
			# Wait for a short amount of time to finish the attack and disable the attack hitbox
		attack_cooldown.start(attack_buffer)  # Start the cooldown timer
	
# Check if the RayCast2D hits the player (used to stop the movement and start attacking)
func is_player_in_attack_range() -> bool:
	# Check if the RayCast2D is colliding and that the collider is a Player
	if attack_range.is_colliding():
		var collider = attack_range.get_collider()
		if collider and collider.is_in_group("Player"):
			return true
	return false


######################################
# Attack Cooldown Management
######################################
func handle_attack_cooldown():
	# When the cooldown finishes, allow the enemy to attack again
	can_attack = true

######################################
# Damage Function
######################################
func take_damage(damage : int):
	super.take_damage(damage)
	health_bar.update(max_health, current_health)
	print("Enemy: " + str(current_health))
	if not is_dead:
		set_physics_process(false)
		sprite.play("hurt")
		await sprite.animation_finished
		set_physics_process(true)
######################################
# Death Functions
######################################
func handle_death():
	sprite.play("death")
	await sprite.animation_finished
	super.handle_death()

func drop_loot():
	# You can add loot-dropping logic here if needed
	pass

######################################
# Detection Functions
######################################
# Called when a body enters the detection area
func _on_body_entered(body: Node):
	if body.is_in_group("Player"):
		is_player_detected = true
		target = body
		player_position = target.position
		# Optionally trigger a state change or event (e.g., start chasing the player)

# Called when a body exits the detection area
func _on_body_exited(body: Node):
	if body.is_in_group("Player"):
		is_player_detected = false
		target = null
		player_position = Vector2.ZERO
		# Optionally stop chasing or reset state when the player leaves the detection area
