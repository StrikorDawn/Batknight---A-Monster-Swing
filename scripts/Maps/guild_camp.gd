extends Node2D

@onready var menu: Node2D = $Menu
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var cam_speed = 200.0
@onready var camera_2d: Camera2D = $Menu/Camera2D
@onready var game_start = false

func _ready() -> void:
	menu.start_game.connect(begin)

func begin():
	if has_node("Menu/Camera2D"):
		game_start = true
		Main.start_game()
		camera_2d.queue_free()
