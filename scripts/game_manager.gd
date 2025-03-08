extends Node

var subscribers := {} # Dictionary to store event subscribers

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	


func subscribe(event_name: String, callback: Callable):
	if not subscribers.has(event_name):
		subscribers[event_name] = []
	subscribers[event_name].append(callback)

func unsubscribe(event_name: String, callback: Callable):
	if subscribers.has(event_name):
		subscribers[event_name].erase(callback)
		if subscribers[event_name].is_empty():
			subscribers.erase(event_name)

func publish(event_name: String, args: Array = []):
	if subscribers.has(event_name):
		for callback in subscribers[event_name]:
			callback.callv(args)
