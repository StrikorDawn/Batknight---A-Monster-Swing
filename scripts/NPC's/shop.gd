extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#when close enough to the shop show details for each of the items
		#speed attack and health boost?
		#maybe create smaller areas for each section/item
		pass
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
