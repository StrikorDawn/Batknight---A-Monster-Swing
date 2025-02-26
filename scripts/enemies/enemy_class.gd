extends CharacterBody2D
class_name EnemyClass

var health : float
var damage : float
var move_speed : int
var loot_drop : int

var is_chasing : bool
var is_dead : bool

func set_health(max_health):
	health = max_health

func attack():
	pass

func do_move():
	pass

func take_damage():
	pass

func drop_loot():
	pass

#const speed = 50
#var is_goblin_chase: bool = true
#
#var health = 80
#var health_max = 80
#var health_min = 0
#
#var dead: bool = false
#var taking_damage: bool = false
#var damage_to_deal = 20
#var is_dealing_damage: bool = false
#
#var dir: Vector2
#const gravity = 900
#var knockback_force = -20
#var is_roaming: bool = true
#
#var player: CharacterBody2D
#var player_in_area = false
