extends ProgressBar

	
func update(max_health, current_health):
	value = current_health * 100 / max_health
	pass
