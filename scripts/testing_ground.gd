extends Node2D

@onready var player: CharacterBody2D = $Player
const BAT = preload("res://scenes/bat.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.bat_thrown.connect(_on_bat_thrown)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_bat_thrown(spawn_point):
	var bat = BAT.instantiate()
	bat.forward_velocity = spawn_point.x * 1
	bat.position = spawn_point
	add_child(bat)
