extends Node2D

const GUILD_CAMP = preload("res://scenes/Maps/guild_camp.tscn")
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#maybe play an animation
	#
	
	pass # Replace with function body.

func _on_button_pressed() -> void:
	start_game.emit()
	
func _on_quit_pressed() -> void:
	get_tree().quit()
