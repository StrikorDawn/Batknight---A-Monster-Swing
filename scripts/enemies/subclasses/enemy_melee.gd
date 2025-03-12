extends EnemyClass
class_name MeleeEnemy

@export var base_health: float = 120.0
@export var health_variance: float = 15.0

@export var base_move_speed: float = 60.0
@export var move_speed_variance: float = 5.0

@export var base_damage: float = 20.0
@export var damage_variance: float = 4.0

@export var base_attack_cooldown: float = 1.0
@export var attack_cooldown_variance: float = 0.2

func _ready():
	super._ready()  # Call base _ready() to set up states and timers
	set_health(base_health, health_variance)
	set_move_speed(base_move_speed, move_speed_variance)
	set_damage(base_damage, damage_variance)
	set_attack_cooldown(base_attack_cooldown, attack_cooldown_variance)
