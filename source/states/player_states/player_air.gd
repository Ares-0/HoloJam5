extends PlayerState

const JUMP_BUFFER: float = 0.2 # maximum time for jump buffer
const COYOTE_TIME: float = 0.2 # maximum time for coyote time

var falling: bool = false # if false, going upwards, if true going downwards
var jump_buffer_timer: float = 0.0 # timer for jump buffer # if this has a value other than 0.0, the player jumps upon landing
var coyote_timer: float = 0.0 # timer for coyote time

var frame_entered: int = 0
var timer: Timer

func enter(old_state: String, msg := {}) -> void:
	frame_entered = Engine.get_frames_drawn()
	jump_buffer_timer = 0.0
	coyote_timer = 0.0

	if player.velocity == Vector2.ZERO and not msg.has("do_jump"):
		print("bad air state enter?")

	if msg.has("do_jump"): # from run or idle
		# player is jumping
		player.velocity.y = player.JUMP_IMPULSE
		falling = false
		player.animation_player.play("jump")
		player.audio_man_ref.play("Jump")
	elif old_state == "Dash" or old_state == "Tilt":
		# tilt or dash upwards
		falling = false
		player.animation_player.play("air_up")
	else: # player velocity.y doesn't read != 0 on this first frame so cant use that to check
		#player is falling (walking off ledge)
		falling = true
		coyote_timer = COYOTE_TIME
		player.animation_player.play("air_fall")

	if old_state == "Tilt":
		player.animation_player.play("tilt")
		timer = Timer.new()
		timer.wait_time = 0.2
		timer.one_shot = true
		timer.autostart = true
		timer.connect("timeout", override_timeout)
		self.add_child(timer)

func exit() -> void:
	if timer != null:
		timer.queue_free()

func physics_update(delta: float) -> void:
	#print(Engine.get_frames_drawn())
	
	# Coyote time
	if coyote_timer > 0.0:
		print(coyote_timer)
		if Input.is_action_just_pressed("jump"):
			finished.emit("Air", {do_jump = true})
		coyote_timer -= delta
	
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

	# Update jump buffer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER

	if not falling:
		# peak of jump
		if player.velocity.y > 0:
			player.reset_gravity()
			falling = true
			player.animation_player.play("air_fall")

	# Change states
	if Input.is_action_just_pressed("dash"):
		if player.can_dash():
			finished.emit("Dash")
	if Input.is_action_just_pressed("tilt"):
		if player.movement_enabled:
			finished.emit("Tilt")
	if player.is_on_floor():
		if jump_buffer_timer > 0.0:
			finished.emit("Air", {do_jump = true})
		if is_zero_approx(input_direction):
			finished.emit("Idle", {do_land = true})
		else:
			finished.emit("Run")
	if player.is_on_wall():
		if abs(last_velocity.x) > 500:
			finished.emit("Tech", {on_wall = true, last_v = last_velocity})

func override_timeout() -> void:
	player.animation_player.play("air_fall")
