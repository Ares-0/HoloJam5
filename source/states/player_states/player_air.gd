extends PlayerState

var falling: bool = false # if false, going upwards, if true going downwards
var frame_entered: int = 0
var timer: Timer

func enter(_old_state: String, msg := {}) -> void:
	frame_entered = Engine.get_frames_drawn()
	if player.velocity == Vector2.ZERO and not msg.has("do_jump"):
		print("bad air state enter?")

	if msg.has("do_jump"):
		# player is jumping
		player.velocity.y = player.JUMP_IMPULSE
		falling = false
		player.animation_player.play("jump")
		player.audio_man_ref.play("Jump")
	elif player.velocity.y > 0:
		#player is falling (walking off ledge)
		falling = true
		player.animation_player.play("air_fall")
	else:
		# tilt or dash upwards
		falling = false
		player.animation_player.play("air_up")

	if msg.has("from_tilt"):
		player.animation_player.play("tilt")
		timer = Timer.new()
		timer.wait_time = 0.6
		timer.one_shot = true
		timer.autostart = true
		timer.connect("timeout", override_timeout)
		self.add_child(timer)

func exit() -> void:
	if timer != null:
		timer.queue_free()

func physics_update(delta: float) -> void:
	#print(Engine.get_frames_drawn())
	# Short jump
	if Input.is_action_just_released("jump") and player.velocity.y < 0: # aka moving upwards
		player.gravity *= 2 # higher multiplier means quicker stop after release

	# Update x velocity
	var input_direction: float = player.get_input_direction()
	if is_zero_approx(input_direction):
		player.velocity.x = move_toward(player.velocity.x, 0, player.AIR_FRICTION*delta)
	else: # todo: apply omni DI
		if abs(player.velocity.x) > player.SPEED:
			# if impulsed, just do friction
			player.velocity.x = move_toward(player.velocity.x, 0, player.AIR_FRICTION*delta)
		else:
			# ramping up to max air speed
			player.velocity.x = move_toward(player.velocity.x, player.AIR_SPEED*input_direction, player.ACCELERATION*delta)		

	var di: Vector2 = player.get_directional_influence()
	# Update y velocity
	var di_y: float = 1.0 + di.y * 0.2
	player.velocity.y += player.gravity * delta * di_y
	var last_velocity: Vector2 = player.velocity # used for tech stuff in an sec
	player.move_and_slide()

	if not falling:
		# peak of jump
		if player.velocity.y > 0:
			player.reset_gravity()
			falling = true
			player.animation_player.play("air_fall")

	# Change states
	if Input.is_action_just_pressed("dash"):
		if player.has_nearest_star() and player.movement_enabled:
			finished.emit("Dash")
	if Input.is_action_just_pressed("tilt"):
		if player.movement_enabled:
			finished.emit("Tilt")
	if player.is_on_floor():
		if is_zero_approx(input_direction):
			finished.emit("Idle", {do_land = true})
		else:
			finished.emit("Run")
	if player.is_on_wall():
		if abs(last_velocity.x) > 500:
			finished.emit("Tech", {on_wall = true, last_v = last_velocity})

func override_timeout() -> void:
	player.animation_player.play("air_fall")
