extends PlayerState

# Short freeze when hitting wall or floor, player can tech backwards
# to preserve momentum
# Just wall tech for now
# Floor is stretch goal

const DURATION: float = 0.15
const SUSTAIN: float = 0.75 # what % of velocity is maintained
var timer: Timer

var initial_v: Vector2 = Vector2.ZERO
var on_wall: bool = false
var on_floor: bool = false

func enter(_old_state: String, msg := {}) -> void:
	on_wall = false
	on_floor = false

	timer = Timer.new()
	timer.wait_time = DURATION
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", tech_timeout)
	self.add_child(timer)

	assert(msg.has("last_v"), "no velocity given to tech state")

	initial_v = msg.get("last_v")

	player.velocity = Vector2.ZERO
	if msg.has("on_wall"):
		on_wall = true
	if msg.has("on_floor"):
		on_floor = true

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		player.velocity = initial_v
		if on_wall:
			player.velocity.x *= -1 * SUSTAIN
		finished.emit("Air")

func tech_timeout() -> void:
	player.velocity = initial_v
	if on_wall:
		player.velocity.x = 0
	finished.emit("Air")

func exit() -> void:
	if timer != null:
		timer.queue_free()
