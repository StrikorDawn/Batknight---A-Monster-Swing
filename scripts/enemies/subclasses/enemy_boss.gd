extends EnemyClass
class_name BossEnemy

@export var base_health: float = 500.0
@export var health_variance: float = 50.0

@export var base_move_speed: float = 30.0
@export var move_speed_variance: float = 5.0

@export var base_damage: float = 40.0
@export var damage_variance: float = 10.0

@export var base_attack_cooldown: float = 2.5
@export var attack_cooldown_variance: float = 0.5

# Boss-specific variable, for example for multiple phases
var phase: int = 1

func _ready():
	super._ready()
	set_health(base_health, health_variance)
	set_move_speed(base_move_speed, move_speed_variance)
	set_damage(base_damage, damage_variance)
	set_attack_cooldown(base_attack_cooldown, attack_cooldown_variance)
	
	# Additional boss initialization: you might set up phase logic, unique attack patterns, etc.
