extends Node

######################################
# Custom Signals
######################################


######################################
# Preloaded Scenes
######################################
const GUILD_CAMP = preload("res://scenes/Maps/guild_camp.tscn")
const CYCLOPES_MAZE = preload("res://scenes/maps/cyclops/maze_base.tscn")
const CYCLOPES_BOSS_ROOM = preload("res://scenes/maps/cyclops/boss_room_base.tscn")

const PLAYER = preload("res://scenes/player/player.tscn")
const BAT = preload("res://scenes/bat/bat.tscn")

######################################
# Node References
######################################
#@onready var pause_menu: Node2D = $"Menus/Pause Menu"
#@onready var pause: Button = $Menus/Pause
@onready var player: CharacterBody2D

######################################
# Other variables
######################################
var current_scene
var player_spawn_point

######################################
# Called when the node enters the 
# scene tree for the first time.
######################################
func _ready() -> void:
	# Instantiate and add the current scene
	current_scene = GUILD_CAMP.instantiate() #change to GUILD_CAMP when done testing 
	add_child(current_scene)

	# Get the player spawn point from the current scene
	player_spawn_point = current_scene.get_node("PlayerSpawn")

	# Instantiate the player
	player = PLAYER.instantiate()

	# Set the player's position to the spawn point's position
	player.position = player_spawn_point.position

	# Add the player to the scene
	add_child(player)

	# Add a Camera2D as a child to the player
	
	#player.add_child(Camera2D.new())

	# Connect the player's bat_thrown signal
	player.bat_thrown.connect(_on_bat_thrown)
	
	#Connect the to boss room signal
	#var cyclopes_maze = CYCLOPES_MAZE.instantiate()
	#cyclopes_maze.boss_room.connect(_set_scene)
	


######################################
# Called every frame. 'delta' is the 
# elapsed time since the previous frame.
######################################
func _process(_delta: float) -> void:
	pass

######################################
# Handles bat spawning logic
######################################
func _on_bat_thrown(spawn_point, is_on_right):
	if player.get_bat_count() > 0:
		var bat = BAT.instantiate()
		bat.bat_grabbed.connect(_on_bat_grabbed)
		if is_on_right == true:
			bat.rotation = 0
			bat.throw_direction = true
		elif is_on_right == false:
			bat.rotation = 180
			bat.throw_direction = false
			
		bat.position = spawn_point
		add_child(bat)
		player.set_bat_count(-1)

######################################
# Allows player to collect bats
######################################
func _on_bat_grabbed():
	player.set_bat_count(1)

######################################
#Functions for the Pause Menu
######################################
#func _on_pause_pressed() -> void:
	#get_tree().paused = true #pause the scene
	#maze.visible = false #hide maze
	#player.visible = false
	#pause.visible = false
	#pause_menu.show_pause() #show pause menu

#func _on_pause_menu_play() -> void:
	#maze.visible = true
	#get_tree().paused = false
	#pause_menu.hide_pause()
	#pause.visible = true
	#player.visible = true
	
######################################
#Navigation
######################################

func _set_scene():
	var new_scene = CYCLOPES_BOSS_ROOM
	load_new_scene(new_scene)

func load_new_scene(new_scene): #set it up to pass the new scene through the 
	#print("print")
	var map = current_scene
	map.queue_free()
	
	
	current_scene = new_scene.instantiate()
	var root = get_tree().root 
	add_child(current_scene)
	
	if current_scene.is_in_group("boss_rooms"):
		var boss_cam = current_scene.get_node("Camera2D")
		boss_cam.make_current()
	
	# Get the player spawn point from the current scene
	player_spawn_point = current_scene.get_node("PlayerSpawn")

	# Set the player's position to the spawn point's position
	player.position = player_spawn_point.position

	# Add a Camera2D as a child to the player
	#player.add_child(Camera2D.new())

	# Connect the player's bat_thrown signal
	#player.add_child(Camera2D.new())
