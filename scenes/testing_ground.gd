extends Node2D

@onready var player: CharacterBody2D = $Player
const BAT = preload("res://scenes/bat.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.bat_thrown.connect(_on_bat_thrown)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_bat_thrown(spawn_point):
	print(spawn_point)
	var bat = BAT.instantiate()
	bat.original_position = spawn_point
	add_child(bat)
