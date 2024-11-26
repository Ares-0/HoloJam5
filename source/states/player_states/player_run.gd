extends PlayerState

func enter(_old_state: String, _msg := {}) -> void:
	player.reset_tilt_charges()
	# I think just animation stuff here
	player.animation_player.play("run")

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		finished.emit("Air")
		return

	var direction: float = player.get_input_direction()

	if not is_zero_approx(direction):
		player.velocity.x = move_toward(player.velocity.x, player.SPEED*direction, player.ACCELERATION*delta)		

	player.move_and_slide()

	if Input.is_action_just_pressed("jump"):
		finished.emit("Air", {do_jump = true})
	elif Input.is_action_just_pressed("dash"):
		if player.can_dash():
			finished.emit("Dash")
	elif is_zero_approx(direction):
		finished.emit("Idle")
