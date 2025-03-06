extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#maybe play an animation
	#
	
	pass # Replace with function body.

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maze.tscn")
