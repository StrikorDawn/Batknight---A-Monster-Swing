extends EnemyClass
class_name RangedEnemy

@export var base_health: float = 100.0
@export var health_variance: float = 10.0

@export var base_move_speed: float = 40.0
@export var move_speed_variance: float = 5.0

@export var base_damage: float = 15.0
@export var damage_variance: float = 3.0

@export var base_attack_cooldown: float = 2.0
@export var attack_cooldown_variance: float = 0.5

# Reference to a projectile scene for ranged attacks
@export var projectile_scene: PackedScene

func _ready():
	super._ready()
	set_health(base_health, health_variance)
	set_move_speed(base_move_speed, move_speed_variance)
	set_damage(base_damage, damage_variance)
	set_attack_cooldown(base_attack_cooldown, attack_cooldown_variance)
	
	# Additional setup for ranged behavior could be added here
