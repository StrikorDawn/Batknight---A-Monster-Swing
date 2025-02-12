extends Node
class_name PlayerState  # This makes it a globally recognized class

var player: Player

func enter_state() -> void:
	pass

func exit_state() -> void:
	pass

func do_physics_process(_delta: float) -> void:
	pass

func do_input(_event: InputEvent) -> void:
	pass
