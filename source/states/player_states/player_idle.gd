extends PlayerState

func enter(_old_state: String, msg := {}) -> void:
	player.reset_tilt_charges()
	if msg.has("do_land"):
		player.animation_player.play("land")
	else:
		player.animation_player.play("idle")

func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		finished.emit("Air")
		return

	# slow to stop
	player.velocity.x = move_toward(player.velocity.x, 0, player.FRICTION*delta)
	player.move_and_slide()
	
	if Input.is_action_just_pressed("jump"):
		finished.emit("Air", {do_jump = true})
	elif Input.is_action_just_pressed("dash"):
		if player.has_nearest_star():
			finished.emit("Dash")
	elif not is_zero_approx(player.get_input_direction()): # last, if nothing pressed
		finished.emit("Run")
		#finished.emit("Run", {ease_in = true, old_facing = idle_facing_right})
