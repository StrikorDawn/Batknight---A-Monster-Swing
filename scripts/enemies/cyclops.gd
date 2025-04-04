extends EnemyBase
class_name EnemyBoss

######################################
# Signal References
######################################
signal dead_boss

######################################
# Node References
######################################
@onready var sprite_2d: AnimatedSprite2D = $Phase1/Sprite2D
@onready var player = get_node("/root/Main/Player")

######################################
# Enemy Variables
######################################
var jump_height = 200
var can_jump: bool = true
var was_on_floor: bool = true  # Track previous floor state
var was_in_air:bool = false # Track if the boss was in the air
const SPEED = 130
var player_distance

func _ready():
	max_health = 50
	attack_damage = 20
	move_speed = 100
	attack_buffer = 1.0
	super._ready()
	
######################################
# Movement Functions
######################################
func _physics_process(delta):
	if not is_dead:
		player_position = detect_player()
		player_distance = player_position.x - global_position.x
		# Apply gravity continuously if not on the floor
		if not is_on_floor():
			velocity.y += GRAVITY * delta  # Apply gravity each frame
		if is_player_detected and target:
			player_position = target.position
		if abs(player_distance) >= 250 and can_attack:
			do_attack()
		else:
			do_move()
		handle_animation()
		
	else:
		handle_death()

# Override the do_move() function to move towards the player
func do_move():
	# Only move if the player is detected
	if abs(player_position.x) < 250:
		# Calculate the direction to move towards the player
		if not is_attacking:
			velocity.x = -direction * move_speed
		else:
			velocity.x = 0
	else:
		# Stop moving if the player is not detected
		velocity.x = 0
	move_and_slide()

######################################
# Handle Animations
######################################
func handle_animation():
	if is_on_floor() and can_jump:
		can_jump = false
		sprite_2d.play("jump")
		await sprite_2d.animation_finished
	elif not is_on_floor(): # Boss is in the air
		sprite_2d.play("in_air")
		was_in_air = true
	elif was_in_air and is_on_floor(): # Boss just landed
		sprite_2d.play("land")
		velocity.x = 0
		await sprite_2d.animation_finished
		can_jump = true
		was_in_air = false # Reset flag after landing
	else: # Boss is idle
		sprite_2d.play("stand")

	# Detect landing
	if is_on_floor() and not was_on_floor:
		sprite_2d.play("land")  # Play landing animation
	was_on_floor = is_on_floor()

######################################
# Combat Functions
######################################
# Trigger the attack if the player is in range (using RayCast2D for stopping movement and starting the attack)
func do_attack():
	if is_on_floor():
		
		var target = player.global_position
		var direction = (target - global_position).normalized()  # Direction toward target

		# Calculate required initial velocity for the jump
		var vy = -sqrt(2 * GRAVITY * jump_height)  # Solve for initial vertical velocity
		var total_time = (vy / GRAVITY) * 2  # Time for a full arc
		var vx = -(target.x - global_position.x) / total_time  # Horizontal velocity

		velocity = Vector2(vx, vy)
		
		await get_tree().create_timer(total_time)  # Wait for the jump duration

		set_physics_process(true)

		await get_tree().create_timer(1).timeout  # Wait before resetting

func detect_player():
	return player.global_position

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
	#sprite.play("death")
	#await sprite.animation_finished
	super.handle_death()
	dead_boss.emit()

func drop_loot():
	# You can add loot-dropping logic here if needed
	pass

######################################
# Detection Functions
######################################
# Called when a body enters the detection area
func _on_body_entered(body: Node):
	#if body.is_in_group("Player"):
		#is_player_detected = true
		#target = body
		#player_position = target.position
	pass
		# Optionally trigger a state change or event (e.g., start chasing the player)

# Called when a body exits the detection area
func _on_body_exited(body: Node):
	#if body.is_in_group("Player"):
		#is_player_detected = false
		#target = null
		#player_position = Vector2.ZERO
		# Optionally stop chasing or reset state when the player leaves the detection area
	pass
