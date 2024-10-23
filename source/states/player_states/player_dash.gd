extends PlayerState

func enter(_old_state: String, _msg := {}) -> void:
	pass
	# todo
	# would like this to stack instead of being a flat value
	# so you can railgun later
	#player.velocity = Vector2.from_angle(player.angle_to_nearest_star) * player.DASH_IMPULSE
	#player.move_and_slide()
	#finished.emit("Air")

func exit() -> void:
	#print("done dashing")
	pass

func physics_update(_delta: float) -> void:
	player.velocity = Vector2.from_angle(player.angle_to_nearest_star) * player.DASH_IMPULSE
	player.move_and_slide()
	if Input.is_action_just_released("dash"):
		finished.emit("Air")
	# If collided with star handled in player script
