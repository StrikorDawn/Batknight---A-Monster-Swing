extends Node2D

@onready var top_door: TileMapLayer = $TopDoor

@onready var GUILD_CAMP = preload("res://scenes/Maps/guild_camp.tscn")

func _on_close_door_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		top_door.enabled = true
		get_node("CloseDoor").queue_free()
		



func _on_to_guild_camp_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Main.load_new_scene(GUILD_CAMP)
