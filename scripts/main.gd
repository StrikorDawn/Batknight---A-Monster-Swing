extends Node

#Map Constants
#const CYCLOPES_MAZE = preload("res://scenes/maps/cyclopes/maze_base.tscn")
#const CYCLOPES_BOSS_ROOM = preload("res://scenes/maps/cyclopes/boss_room_base.tscn")
#
#var maze = CYCLOPES_MAZE

#@onready var pause_menu: Node2D = $"Menus/Pause Menu"
#@onready var pause: Button = $Menus/Pause

@onready var player: CharacterBody2D = $Player
const BAT = preload("res://scenes/bat/bat.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.bat_thrown.connect(_on_bat_thrown)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_bat_thrown(spawn_point, is_on_right):
	if player.get_bat_count() > 0:
		var bat = BAT.instantiate()
		bat.bat_grabbed.connect(_on_bat_grabbed)
		if is_on_right == true:
			bat.rotation = 0
			bat.throw_direction = true
		elif is_on_right == false:
			bat.rotation = 270
			bat.throw_direction = false
			
		bat.position = spawn_point
		add_child(bat)
		player.set_bat_count(-1)

func _on_bat_grabbed():
	player.set_bat_count(1)


#Functions for the Pause Menu

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
