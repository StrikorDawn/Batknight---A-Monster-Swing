extends Node2D

@onready var top_door: TileMapLayer = $TopDoor
@onready var side_door: TileMapLayer = $SideDoor
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var GUILD_CAMP = preload("res://scenes/Maps/guild_camp.tscn")
const CYCLOPES = preload("res://scenes/enemies/cyclopes.tscn")

func _on_close_door_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		top_door.enabled = true
		get_node("CloseDoor").queue_free()
		

func _open_escape_door():
	side_door.enabled = false

func _on_to_guild_camp_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Main.load_new_scene(GUILD_CAMP)


func _on_start_boss_battle_body_entered(body: Node2D) -> void:
	audio_stream_player.play()
	if body.is_in_group("Player"):
		var boss_boi = CYCLOPES.instantiate()
		add_child(boss_boi)
		var boss_spawn = get_node("BossSpawn")
	
		boss_boi.position = boss_spawn.position
	
		boss_boi.start_boss_fight()
		
		boss_boi.dead_boss.connect(_open_escape_door)
	
		get_node("StartBossBattle").queue_free()
	
