extends PlayerState

var exit_by_click: bool = false

func enter(_old_state: String, _msg := {}) -> void:
	exit_by_click = false
	player.reset_gravity()

func exit() -> void:
	#print("done dashing")
	pass
	if not exit_by_click: # aka exited via collision
		player.velocity = Vector2.from_angle(player.angle_to_nearest_star) * player.DASH_IMPULSE * 1.2
		player.move_and_slide()
		pass

func physics_update(_delta: float) -> void:
	# todo
	# would like this to stack instead of being a flat value
	# so you can railgun later
	player.velocity = Vector2.from_angle(player.angle_to_nearest_star) * player.DASH_IMPULSE
	player.move_and_slide()
	if Input.is_action_just_released("dash"):
		exit_by_click = true
		finished.emit("Air")
	# If collided with star handled in player script
