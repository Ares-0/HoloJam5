extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player_ref: Player = null
var facing_right: bool = false

func _ready() -> void:
	player_ref = null
	facing_right = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if player_ref != null:
		facing_right = player_ref.position.x > self.position.x
		$SpriteL.visible = !facing_right
		$SpriteR.visible = facing_right

func _on_area_2d_area_entered(area: Area2D) -> void:
	# this is so dumb but I dont have time
	if area.get_parent() is Player:
		player_ref = area.get_parent()
