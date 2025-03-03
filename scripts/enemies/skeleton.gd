extends EnemyClass

func _ready() -> void:
	set_health(80)
	var move_speed = 200 #maybe lower to 150
	
func _physics_process(delta: float) -> void:
	pass
	
func take_damage():
	pass
	
func shoot_arrow():
	pass
	
func idle():
	pass
	#when skele not in range of the player
	#
