extends PlayerState

func enter(_old_state: String, _msg := {}) -> void:
	# todo
	# would like this to stack instead of being a flat value
	# so you can railgun later
	player.velocity = Vector2.from_angle(player.angle_to_nearest_star) * player.DASH_IMPULSE
	player.move_and_slide()
	finished.emit("Air")
