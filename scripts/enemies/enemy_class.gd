extends CharacterBody2D  # Inherits from CharacterBody2D for movement and physics
class_name EnemyClass  # Ensures this is recognized as a class that can be inherited from

######################################
# Custom Signals
######################################
signal enemy_defeated  # Signal emitted when the enemy is defeated

######################################
# Node References
######################################
var animated_sprite : AnimatedSprite2D  # Animated sprite for enemy animations

######################################
# Enemy Variables
######################################
var health : float  # Current health of the enemy
var max_health : float  # Maximum health of the enemy
var move_speed : float  # Movement speed of the enemy
var damage : float  # Damage dealt by the enemy
var direction  # Direction of movement (custom logic needed)
var attack_cooldown : float  # Time between attacks (custom logic needed)
var gravity : float = 1000.0  # Gravity applied to the enemy
var loot_drop : int = 0  # Loot to be dropped upon death (replace with actual loot logic)

######################################
# Enemy State
######################################
var is_alive : bool = true  # Flag indicating if the enemy is alive
var is_hit : bool = false
var i_frames : float = 1.0  # Time in seconds the enemy is invincible after being hit
var invincible : bool = false  # Flag to check if the enemy is in invincibility state
var invincibility_timer : Timer  # Timer node to handle invincibility duration

######################################
# Enemy Setters
######################################
func set_health(value: float):
	max_health = value
	health = max_health

func set_move_speed(value : float):
	move_speed = value

func set_damage(value: float):
	damage = value

func set_animated_sprite(sprite : AnimatedSprite2D):
	animated_sprite = sprite
######################################
# Ready Function (Initialization)
######################################
func _ready():
	add_to_group("Enemy")  # Add enemy to group for easier management
	invincibility_timer = Timer.new()  # Create timer node for invincibility
	invincibility_timer.one_shot = true  # Set timer to stop after one cycle
	invincibility_timer.connect("timeout", _on_invincibility_timeout)  # Connect timer to callback
	add_child(invincibility_timer)  # Add timer as a child to this enemy

######################################
# Enemy Movement Logic
######################################
func _physics_process(delta):
	if is_alive:
		velocity.y += gravity * delta  # Apply gravity to the velocity (Y component)
		do_move(delta)  # Custom movement logic, can be overridden in subclasses
		move_and_slide()  # Move and slide with the calculated velocity
		handle_animation()  # Handle animations based on current state

# Custom move logic (to be implemented in subclasses)
func do_move(_delta: float):
	pass  # Subclasses will override this for specific movement behavior

######################################
# Enemy Animation Handling
######################################
func handle_animation():
	pass  # Handle animations (e.g., idle, walk, attack, etc.) based on current state

######################################
# Enemy Battle Logic
######################################
# Handle taking damage and starting death sequence
func take_damage(amount: float):
	if is_alive and not invincible:  # Check if the enemy is alive and not invincible
		is_hit = true
		health -= amount
		health = max(health, 0)  # Prevent negative health
		print(health)
		if health <= 0:
			die()  # Call die() method when health reaches zero
		else:
			invincible = true  # Set invincible to true after taking damage
			invincibility_timer.start(i_frames)  # Start the invincibility timer
	else:
		print("Enemy is Invincible")

func attack(_target: Node):
	pass  # To be overridden in subclasses for specific attack logic

# Handle enemy death
func die():
	is_alive = false  # Set enemy to dead state
	drop_loot()  # Drop loot when the enemy dies
	start_death_sequence()  # Trigger the death sequence (e.g., animations, effects)

# Loot dropping logic
func drop_loot():
	if loot_drop > 0:
		print("Loot dropped!")  # Replace with actual loot logic
		# Example: spawn a loot item in the world
		#var loot = LootItem.new()  # Assuming you have a LootItem class
		#get_parent().add_child(loot)  # Add loot to the scene

# Death sequence logic
func start_death_sequence():
	if is_alive:
		return  # If still alive, do nothing
	else:
		print("Enemy death sequence triggered!")  # Custom death handling (e.g., animation or effects)
		animated_sprite.play("death")
		await animated_sprite.animation_finished
		emit_signal("enemy_defeated")  # Emit signal when enemy is defeated
		queue_free()  # Or trigger animation instead

# Callback for when the invincibility timer expires
func _on_invincibility_timeout():
	invincible = false  # End invincibility
	print("Vincible")
