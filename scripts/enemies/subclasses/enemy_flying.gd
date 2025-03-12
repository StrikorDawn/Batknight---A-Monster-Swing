extends EnemyClass
class_name FlyingEnemy

@export var base_health: float = 80.0
@export var health_variance: float = 10.0

@export var base_move_speed: float = 70.0
@export var move_speed_variance: float = 10.0

@export var base_damage: float = 12.0
@export var damage_variance: float = 2.0

@export var base_attack_cooldown: float = 1.5
@export var attack_cooldown_variance: float = 0.3

func _ready():
	super._ready()
	set_health(base_health, health_variance)
	set_move_speed(base_move_speed, move_speed_variance)
	set_damage(base_damage, damage_variance)
	set_attack_cooldown(base_attack_cooldown, attack_cooldown_variance)
	
	# For flying enemies, you might want to disable standard gravity.
	gravity = 0
	
	# Optionally, you can add custom flying logic here (e.g., swooping behavior).
