extends CharacterBody2D
class_name EnemyBase

@export var max_health: int = 100
@export var move_speed: float = 50.0
@export var detection_radius: float = 300.0
@export var attack_range: float = 50.0
@export var vision_angle: float = 90.0  # Field of vision for stealth
@export var patrol_points: Array[Vector2]  # List of patrol positions
@export var patrol_speed: float = 30.0
@export var path_update_interval: float = 0.5  # How often path updates

var current_health: int
var player = null
var current_patrol_index = 0
var is_chasing = false
var path_update_timer = 0.0

@onready var navigation_agent = $NavigationAgent2D
@onready var sprite = $Sprite2D
@onready var attack_area = $Area2D

func _ready():
	current_health = max_health
	player = get_tree().get_first_node_in_group("Player")  # Find the player in the scene

func _process(delta):
	if not player:
		return

	path_update_timer -= delta

	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player <= detection_radius and can_see_player():
		is_chasing = true
		if path_update_timer <= 0:
			path_update_timer = path_update_interval
			navigation_agent.target_position = player.global_position
	elif is_chasing:
		is_chasing = false
		go_to_next_patrol_point()

	if is_chasing and distance_to_player <= attack_range:
		attack()

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
	
	var direction = (navigation_agent.get_next_path_position() - global_position).normalized()
	velocity = direction * (move_speed if is_chasing else patrol_speed)
	move_and_slide()

func attack():
	print("Enemy attacks!")  # Placeholder, melee enemies override this

func take_damage(amount: int):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	queue_free()  # Destroy the enemy

func go_to_next_patrol_point():
	if patrol_points.is_empty():
		return
	
	navigation_agent.target_position = patrol_points[current_patrol_index]
	current_patrol_index = (current_patrol_index + 1) % patrol_points.size()

func can_see_player() -> bool:
	if not player:
		return false
	
	var direction_to_player = (player.global_position - global_position).normalized()
	var enemy_facing_direction = Vector2.RIGHT.rotated(rotation)  # Assumes enemy faces right

	var angle_between = rad_to_deg(enemy_facing_direction.angle_to(direction_to_player))
	
	return abs(angle_between) <= vision_angle / 2
