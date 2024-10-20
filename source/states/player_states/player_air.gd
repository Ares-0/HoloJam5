extends PlayerState

var falling: bool = false # if false, going upwards, if true going downwards

func enter(_old_state: String, msg := {}) -> void:
	# player is jumping
	if msg.has("do_jump"):
		player.velocity.y = player.JUMP_VELOCITY
		falling = false
	else:
		#player is falling
		falling = true

func physics_update(delta: float) -> void:
	# Short jump
	if Input.is_action_just_released("jump") and player.velocity.y < 0: # aka moving upwards
		player.gravity *= 2 # higher multiplier means quicker stop after release
	
	# Update x movement
	var input_direction: float = player.get_input_direction()
	if not is_zero_approx(input_direction):
		#player.velocity.x = direction * player.SPEED # 1 frame velocity update
		player.velocity.x = move_toward(player.velocity.x, player.SPEED*input_direction, player.ACCELERATION*delta)		
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.AIR_FRICTION*delta)

	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	if not falling:
		# peak of jump
		if player.velocity.y > 0:
			player.reset_gravity()
			falling = true

	# Change states
	if Input.is_action_just_pressed("dash"):
		if player.has_nearest_star():
			finished.emit("Dash")
	if player.is_on_floor():
		if is_zero_approx(input_direction):
			finished.emit("Idle", {do_land = true})
		else:
			finished.emit("Run")
