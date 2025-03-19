extends EnemyClass

@onready var max_health = 3.0

func _ready() -> void:
	
	set_health(max_health)
	
	
#attack function
	#
