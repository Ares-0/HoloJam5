extends PlayerState

func enter(_old_state: String, _msg := {}) -> void:
	pass
	player.velocity = Vector2.from_angle(player.angle_to_nearest_star) * player.DASH_IMPULSE
	player.move_and_slide()
	finished.emit("Air")
