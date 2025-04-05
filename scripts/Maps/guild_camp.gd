extends Node2D

@onready var menu: Node2D = $Menu
@onready var player_spawn: Marker2D = $PlayerSpawn
@onready var cam_speed = 200.0
@onready var camera_2d: Camera2D = $Menu/Camera2D
@onready var game_start = false

func _ready() -> void:
	menu.start_game.connect(begin)
		
	
	
func begin():
	game_start = true
	Main.start_game()
	camera_2d.queue_free()

#var speed: float = 5.0

#func _process(delta):
	#position = position.lerp(player_spawn.position, 1 - exp(-speed * delta))
	
