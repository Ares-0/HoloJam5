extends PlayerState

var dash_impulse: float = 1200.0

func enter(_old_state: String, _msg := {}) -> void:
	pass
	player.velocity = Vector2.from_angle(player.angle_to_nearest_star) * dash_impulse
	player.move_and_slide()
	finished.emit("Air")
