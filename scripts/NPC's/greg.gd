extends Area2D

@onready var to_maze: Button = $ToMaze
@onready var main: Node = $"."
const CYCLOPES_MAZE = preload("res://scenes/Maps/cyclopes/maze_base.tscn")
const GUILD_CAMP = preload("res://scenes/Maps/guild_camp.tscn")

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		to_maze.visible = true
		to_maze.disabled = false

func _on_body_exited(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		to_maze.visible = false
		to_maze.disabled = true

func _on_to_maze_pressed() -> void:
	var current_scene = GUILD_CAMP
	var maze = CYCLOPES_MAZE
	Main.load_new_scene(maze) #this might work but it is still a work in progress
	pass # Replace with function body.
