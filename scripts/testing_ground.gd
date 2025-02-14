extends Node2D

@onready var player: CharacterBody2D = $Player
const BAT = preload("res://scenes/bat.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.bat_thrown.connect(_on_bat_thrown)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_bat_thrown(spawn_point, is_on_right):
	var bat = BAT.instantiate()
	if is_on_right == true:
		bat.rotation = 0
	elif is_on_right == false:
		bat.rotation = 270
	
	bat.position = spawn_point
	
	add_child(bat)
