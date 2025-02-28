extends Node2D

signal boss_room

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#Reset Button

func reload_maze():
	get_tree().reload_current_scene()

func _on_button_pressed() -> void:
	reload_maze()
	#This function and its related button are for debugging only and should be removed later

#Navigation

func _on_to_boss_room_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): #only the player can trigger the next level
		boss_room.emit()
	
