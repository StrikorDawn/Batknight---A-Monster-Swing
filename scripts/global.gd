extends Node

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
