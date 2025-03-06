extends Node2D

#signal for play button pressed
signal play

@onready var canvas_layer: CanvasLayer = $CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func show_pause():
	visible = true
	canvas_layer.visible = true

func hide_pause():
	visible = false
	canvas_layer.visible = false
	
func options():
	pass
	#opens the options menu
	#for now make it the player spawns for testing
	
func main_menu():
	pass
	#returns player to the main menu
	#if we can figure out how to save game files ask player to save first

func canvas_visible():
	canvas_layer.visible != canvas_layer.visible


func _on_play_pressed() -> void:
	play.emit()
