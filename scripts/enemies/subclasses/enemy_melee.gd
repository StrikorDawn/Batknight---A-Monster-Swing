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

######################################
# Enemy Variables
######################################
func _ready():
	super._ready()
	max_health = 50
	current_health = max_health
	attack_damage = 20
	move_speed = 100
	attack_buffer = 0.75

	sprite.connect("animation_finished", _on_attack_animation_finished)
######################################
# Movement Functions
######################################

func _physics_process(delta):
	super._physics_process(delta)
	if is_player_detected and target:
		player_position = target.position
	if is_player_in_attack_range():
		do_attack()
# Override the do_move() function to move towards the player
func do_move():
	# Only move if the player is detected
	if is_player_detected and not is_player_in_attack_range():
		# Calculate the direction to move towards the player
		_update_direction()
		velocity.x = direction * move_speed
		handle_animation()
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
		if velocity.x != 0:
			sprite.play("run")  # Play running animation if the player is detected
	else:
		if velocity.x == 0:
			sprite.play("idle")  # Play idle animation if no player is detecte

######################################
# Combat Functions
######################################
# Trigger the attack if the player is in range (using RayCast2D for stopping movement and starting the attack)
func do_attack():
	if is_player_in_attack_range() and can_attack:
		# Handle attacking logic here
		can_attack = false
		sprite.play("attack")
		attack_area.monitoring = true # Enable the attack hitbox
		
		if attack_area.overlaps_body(target):
			print("Take that!!!")
		else:
			print("I Missed")
				
		# Wait for a short amount of time to finish the attack and disable the attack hitbox
		attack_cooldown.start(attack_buffer)  # Start the cooldown timer
	else:
		print("Can't Attack yet")
		  
func _on_attack_animation_finished():
	# Disable the attack hitbox
	attack_area.monitoring = false
	
# Check if the RayCast2D hits the player (used to stop the movement and start attacking)
func is_player_in_attack_range() -> bool:
	# Check if the RayCast2D is colliding and that the collider is a Player
	if attack_range.is_colliding():
		var collider = attack_range.get_collider()
		if collider.is_in_group("Player"):
			return true
	return false


######################################
# Attack Cooldown Management
######################################
func handle_attack_cooldown():
	# When the cooldown finishes, allow the enemy to attack again
	can_attack = true

######################################
# Death Functions
######################################
func handle_death():
	if is_dead:
		queue_free()  # Free the enemy when it's dead

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
