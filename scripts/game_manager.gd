extends Node

########################
#This code is not in use as of 3/14
########################


<<<<<<< Updated upstream
<<<<<<< Updated upstream
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
=======
=======
>>>>>>> Stashed changes
const PLAYER = preload("res://scenes/player/player.tscn")

func load_new_scene(new_scene, current_scene): #set it up to pass the new scene through the 
	#print("print")
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
	
	var map = current_scene
	map.queue_free()
	
	current_scene = new_scene.instantiate()
	var root = get_tree().root 
	root.add_child(current_scene)
	
	# Get the player spawn point from the current scene
	#var player_spawn_point = current_scene.get_node("PlayerSpawn")
#
	## Set the player's position to the spawn point's position
	#player.position = player_spawn_point.position

	# Add a Camera2D as a child to the player
	#player.add_child(Camera2D.new())




#var subscribers := {} # Dictionary to store event subscribers
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass
	#
#
#
#func subscribe(event_name: String, callback: Callable):
	#if not subscribers.has(event_name):
		#subscribers[event_name] = []
	#subscribers[event_name].append(callback)
#
#func unsubscribe(event_name: String, callback: Callable):
	#if subscribers.has(event_name):
		#subscribers[event_name].erase(callback)
		#if subscribers[event_name].is_empty():
			#subscribers.erase(event_name)
#
#func publish(event_name: String, args: Array = []):
	#if subscribers.has(event_name):
		#for callback in subscribers[event_name]:
			#callback.callv(args)
