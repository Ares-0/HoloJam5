extends PlayerState

var exit_by_click: bool = false
var start_frame: int = 0
var star_ref: Star = null

func enter(_old_state: String, _msg := {}) -> void:
	exit_by_click = false
	start_frame = Engine.get_frames_drawn()
	star_ref = player.nearest_star
	player.reset_gravity()
	player.audio_man_ref.play("Dash")
	player.animation_player.play("dashing")

func exit() -> void:
	#print("done dashing")
	player.recently_dashed_timer_start()
	if not exit_by_click: # aka exited via collision
		player.velocity = Vector2.from_angle(player.angle_to_nearest_star) * player.DASH_IMPULSE * 1.2 * player.nearest_star.force_multiplier
		player.move_and_slide()

func physics_update(_delta: float) -> void:
	# todo
	# would like this to stack instead of being a flat value
	# so you can railgun later
	var new_v: Vector2 = Vector2.from_angle(player.angle_to_nearest_star) * player.DASH_IMPULSE
	new_v = new_v * star_ref.force_multiplier
	player.velocity = new_v

	player.move_and_slide()
	if Input.is_action_just_released("dash"):
		exit_by_click = true
		finished.emit("Air")
		return
	# If collided with star handled in player script

	# want this to be after the click check
	var frames_elapsed: int = Engine.get_frames_drawn() - start_frame
	if frames_elapsed % 6 == 0:
		player.audio_man_ref.play("Dash")
