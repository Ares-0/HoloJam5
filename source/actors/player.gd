class_name Player
extends CharacterBody2D


const SPEED = 300.0 # really should be max speed
const JUMP_VELOCITY = -600.0
const ACCELERATION = 60.0*50.0 # per second aka per 60 frames, so N is delta per frame
const FRICTION = 60.0*30.0
const AIR_FRICTION = 60.0*10.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity") # default default is 980

var last_direction: float = 0.0

@onready var machine: StateMachine = $StateMachine
@onready var dlabel: DebugLabel = $DebugLabel

func _ready() -> void:
	# Prep initial is_on_floor
	velocity = Vector2.ZERO
	move_and_slide()

func _physics_process(_delta: float) -> void:
	dlabel.update_line(0, str("State: ", machine.state.name))
	dlabel.update_line(1, str(gravity))

func get_input_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")

	# I do not like this here
	#if last_direction != direction and direction != 0:
		#update_sprites(direction)

	last_direction = direction
	return direction

func reset_gravity() -> void:
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
