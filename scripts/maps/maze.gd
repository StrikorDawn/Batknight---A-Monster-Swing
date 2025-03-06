extends Node2D

@onready var pause_menu: Node2D = $"Pause Menu"

signal boss_room

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reload_maze():
	get_tree().reload_current_scene()
	



func _on_button_pressed() -> void:
	get_tree().paused = true
	$TileMap.visible = false
	show_pause()
	
func show_pause():
	pause_menu.visible = true
	pause_menu.canvas_visible()
	$Player/Camera2D.enabled = false
	#turn on visibility for pause menu 
	#check to make sure you cant press buttons while menu is invisible 

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
	
