extends EnemyClass
class_name MeleeEnemy

######################################
# Node References
######################################
@onready var goblin_melee_hitbox: Area2D = $GoblinMeleeHitbox
@onready var attack_hitbox: Area2D = $AttackHitbox


######################################
# Enemy Melee Attributes
######################################
@export var attack_damage: float = 15.0
@export var attack_duration: float = 0.2  # How long the hitbox remains active

######################################
# Enemy Melee State Variables
######################################
var attack_ready: bool = true
var is_facing_right: bool = true

######################################
# Initialization
######################################
func _ready():
	super._ready()  # Ensure parent class initialization
	set_sprite($CollisionShape2D/AnimatedSprite2D)
	set_move_speed(200)
	set_health(60)
	set_damage(attack_damage)
	set_attack_cooldown(1.0)
	attack_hitbox.body_entered.connect(_on_attack_area_body_entered)
	attack_hitbox.monitoring = false  # Disable attack hitbox initially

######################################
# Attack Handling
######################################
func _on_attack_area_body_entered(body):
	if body.is_in_group("Player") and attack_ready:
		perform_attack()

func perform_attack():
	if not attack_ready:
		return
	
	attack_ready = false
	
	# Activate attack hitbox and position it correctly
	activate_attack_hitbox()
	
	# Wait for the attack duration, then deactivate
	await get_tree().create_timer(attack_duration).timeout
	deactivate_attack_hitbox()
	
	# Start cooldown before the next attack
	await get_tree().create_timer(attack_cooldown).timeout
	attack_ready = true

func activate_attack_hitbox():
	# Adjust position based on facing direction
	if is_facing_right:
		attack_hitbox.position.x = 28  # Offset forward
		attack_hitbox.rotation_degrees = 0
	else:
		attack_hitbox.position.x = -28
		attack_hitbox.rotation_degrees = 180
	
	attack_hitbox.monitoring = true  # Enable attack detection

func deactivate_attack_hitbox():
	attack_hitbox.monitoring = false  # Disable attack detection

######################################
# Hitbox Damage Processing
######################################
func _on_attack_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(attack_damage)
