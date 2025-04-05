extends EnemyBase

######################################
# Custom Signals
######################################
signal dead_boss

######################################
# Node References
######################################
@onready var player = get_node("/root/Main/Player")
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var hit_area: Area2D = $HitArea


######################################
# Boss Variables
######################################
var jump_height = 200
var distance
var can_jump: bool = true

######################################
# Boss Set Up
######################################
func _ready() -> void:
	move_speed = 450
	max_health = 100
	attack_damage = 15
	super._ready()

var was_on_floor = true  # Track previous floor state

var was_in_air = false # Track if the boss was in the air

######################################
# Boss Frame by Frame logic
######################################
func _physics_process(delta: float) -> void:
	if not is_dead:
		direction = sign(player.global_position.x - global_position.x)
		was_on_floor = is_on_floor()
		if not is_on_floor():
			apply_gravity(delta)
		else:
			detect_player()
			if distance > 250:
				small_jump()
			else:
				if is_on_wall():
					jump_away_from_wall()
				else:
					do_move()

		handle_animation()
		move_and_slide()
	else:
		handle_death()

func handle_animation():
	if is_on_floor() and can_jump:
		can_jump = false
		sprite_2d.play("jump")
		
	elif not is_on_floor(): # Boss is in the air
		sprite_2d.play("in_air")
		was_in_air = true
		
	elif was_in_air and is_on_floor(): # Boss just landed
		sprite_2d.play("land")
		velocity.x = 0
		await get_tree().create_timer(.5).timeout
		can_jump = true
		was_in_air = false # Reset flag after landing
		
	else: # Boss is idle
		sprite_2d.play("stand")
	
######################################
# 
######################################
func do_move():
	velocity.x = direction * -move_speed

func jump_away_from_wall():
	var vy = -sqrt(2 * GRAVITY * jump_height)
	var vx = direction * 600 # push away from wall horizontally
	velocity = Vector2(vx, vy)

func detect_player():
	distance = player.global_position.distance_to(global_position)

func handle_death():
	dead_boss.emit() 
	super.handle_death()

func small_jump():
	if is_on_floor():
		# Calculate required initial velocity for the jump
		var vy = -sqrt(2 * GRAVITY * jump_height)  # Solve for initial vertical velocity
		var total_time = (vy / GRAVITY) * 2  # Time for a full arc
		var vx = -(player.global_position.x - global_position.x) / total_time  # Horizontal velocity
		velocity = Vector2(vx, vy)

func _on_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.


func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(attack_damage, global_position)
