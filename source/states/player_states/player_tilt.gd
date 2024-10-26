extends PlayerState

# A short burst of momentum in a direction indicated by the arrow keys
# Used for quick correction or an extra bit of distance
# Only used from the air state

const DURATION: float = 0.08
var timer: Timer
var dir: Vector2

func enter(_old_state: String, _msg := {}) -> void:
	# todo: hide arrow during tilt

	if player.get_tilt_charges() == 0:
		finished.emit("Air") # this works and doesn't (seem to) mess up Air
		return
	else:
		player.decrement_tilt_charge()

	dir = player.get_directional_influence()
	# I think there's a place for this somewhere, but it feels bad atm
	if dir == Vector2.ZERO:
		finished.emit("Air")
		return

	player.audio_man_ref.play("Tilt")
	player.velocity = dir * player.TILT_IMPULSE * 2
	player.move_and_slide()

	timer = Timer.new()
	timer.wait_time = DURATION
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", tilt_timeout)
	self.add_child(timer)

func exit() -> void:
	if timer != null:
		timer.queue_free()

func physics_update(_delta: float) -> void:
	player.velocity = dir * player.TILT_IMPULSE
	player.move_and_slide()

func tilt_timeout() -> void:
	player.velocity = player.velocity / 2
	finished.emit("Air")
