extends EnemyBase
class_name MeleeEnemy

######################################
# Node References
######################################
@onready var attack_point = $AttackPoint
@onready var attack_area = $AttackPoint/AttackArea
@onready var detection_area = $"DetectionArea"
@onready var attack_cooldown = $AttackCooldown
@onready var attack_range = $AttackPoint/AttackArea/AttackRange

######################################
# Enemy Variables
######################################
var is_player_detected : bool = false

######################################
# Movement Functions
######################################
func _ready():
	super._ready()
	max_health = 50
	current_health = max_health
	attack_damage = 20
	move_speed = 100
	attack_buffer = 0.75

# Override the do_move() function to move towards the player
func do_move():
	# Only move if the player is detected
	if is_player_detected:
		# Calculate the direction to move towards the player
		var direction = (detection_area.position - position).normalized()
		velocity = direction * move_speed
		move_and_slide()
		_update_direction()
	else:
		# Stop moving if the player is not detected
		velocity.x = 0

# Update direction based on velocity for correct facing
func _update_direction():
	if velocity.x > 0:
		direction = 1
		is_facing_left = false
	elif velocity.x < 0:
		direction = -1
		is_facing_left = true

######################################
# Combat Functions
######################################
# Trigger the attack if the player is in range (using RayCast2D for stopping movement and starting the attack)
func do_attack():
	if is_player_in_attack_range() and can_attack:
		# Handle attacking logic here
		can_attack = false
		attack_area.monitoring = true  # Enable the attack hitbox
		attack_cooldown.start(attack_buffer)  # Start the cooldown timer

		# Wait for a short amount of time to finish the attack and disable the attack hitbox
		await get_tree().create_timer(0.2).timeout
		attack_area.monitoring = false  # Disable the attack hitbox

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
		# Optionally trigger a state change or event (e.g., start chasing the player)

# Called when a body exits the detection area
func _on_body_exited(body: Node):
	if body.is_in_group("Player"):
		is_player_detected = false
		# Optionally stop chasing or reset state when the player leaves the detection area
