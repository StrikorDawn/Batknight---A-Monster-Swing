extends CharacterBody2D

# As of 3/19 this code is not connecting to the instantiated cyclopes in the boss room
#I have no idea why...
@onready var player = get_node("/root/Main/Player")

@onready var max_health = 100
@onready var health = max_health
@onready var jump_height = 200

@onready var p_1: CollisionShape2D = $Phase1/P1HitBox/P1
@onready var side_attack_area: CollisionPolygon2D = $SideAttack/SideAttackArea

@onready var boss_battle: bool

const SPEED = 130

signal dead_boss

func _ready() -> void:
	set_physics_process(false)
	#function to run starting animation
	pass
	
func _physics_process(delta: float) -> void:
	var gravity = ProjectSettings.get("physics/2d/default_gravity")
	
	# Apply gravity
	velocity.y += gravity * delta
	move_and_slide()
	

func take_damage():
	health = health - 10
	print(health)
	
	if health <= 0:
		dead()
	
func _on_p_1_hit_box_body_entered(body: Node2D) -> void: #currently broken
	
	if body.is_in_group("Attacks"): #checks for collision shapes in the attacks group
		take_damage() #reduces boss's health
		p_1.disabled = true #turns off collision shape temporarily
		await get_tree().create_timer(.6).timeout
		p_1.disabled = false 
	
func dead():
	boss_battle = false
	queue_free()
	dead_boss.emit() #opens the exit door
	#include wahtever exit text here
	

func start_boss_fight():
	boss_battle = true
	#play starting animation
	await get_tree().create_timer(.5).timeout
	#print("boss battle start")
	set_physics_process(true)
	
	while (boss_battle == true):
		var distance = find_player_distance()
		print(distance)
	
		if distance <= 450:
			if is_on_floor():
				await get_tree().create_timer(.75).timeout
				side_to_side() 
			else:
				await get_tree().create_timer(.75).timeout
		
			#side to side attack
			#boss moves closer then does attack
		elif distance > 450:
			if is_on_floor():
				await get_tree().create_timer(.75).timeout
				jump_attack()
			else:
				await get_tree().create_timer(.75).timeout
	#get player and self location
	#find distance between player and self
	#if distance > x do this 
	
	pass
	
	
func find_player_distance():
	var player_global_position = player.global_position
	#print(player_global_position)
	var boss_global_position = global_position
	#print(boss_global_position)
	
	var distance = player_global_position.distance_to(boss_global_position)
	return distance
	
func jump_attack():

	if is_on_floor():
		small_jump()
	
	if is_on_floor():
		small_jump()
	
	
	
	
func small_jump():
	
	var target = player.global_position
	var direction = (target - global_position).normalized()  # Direction toward target
	
	# Calculate required initial velocity for the jump
	var gravity = ProjectSettings.get("physics/2d/default_gravity")
	
	var vy = -sqrt(2 * gravity * jump_height)  # Solve for initial vertical velocity
	var total_time = (vy / gravity) * 2  # Time for a full arc
	var vx = -(target.x - global_position.x) / total_time  # Horizontal velocity
	
	velocity = Vector2(vx, vy)
	await get_tree().create_timer(total_time)
	set_physics_process(true)
	await get_tree().create_timer(1).timeout
	
	
func side_to_side():
	#play attack animation
	print("side")
	
	#Cyclopes can't slide or move? I think
	set_physics_process(false)
	
	#enables the collision shape for the side attack
	side_attack_area.disabled = false
	
	#Time for the attack
	await get_tree().create_timer(1) #probably could be reduced
	
	#Switches the direction of the sprite
	self.scale.x = scale.x * (-1)

	#time for part two of the attack
	await get_tree().create_timer(1)
	
	#disables the hitbox
	side_attack_area.disabled = true
	
	#unflips the sprite
	self.scale.x = scale.x * (-1)
	
	#cyclopes can move again
	set_physics_process(true)
	

#Phase 1
	#jump and slam attack
		#ripple
	#side to side attack


#Phase 2
	#down swipe
	#side slam
