extends EnemyState
class_name EnemyAlertState

var alert_time: float = 1.5  # Time to stay alert before chasing
var timer: float = 0.0

func enter_state(enemy_instance):
	super.enter_state(enemy_instance)

	# Set alert animation
	if enemy.animated_sprite:
		enemy.animated_sprite.play("alert")

	# Reset alert timer
	timer = 0.0

func do_physics_process(delta: float) -> void:
	timer += delta
	
	# If the player is still detected after alert_time, transition to chase
	if enemy.player_detected and timer >= alert_time:
		enemy.change_state("Chase")
	elif not enemy.player_detected:
		enemy.change_state("Idle")  # Return to idle if player leaves
