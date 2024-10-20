class_name Player
extends CharacterBody2D


const SPEED = 300.0 # really should be max speed
const JUMP_VELOCITY = -600.0
const ACCELERATION = 60.0*50.0 # per second aka per 60 frames, so N is delta per frame
const FRICTION = 60.0*30.0
const AIR_FRICTION = 60.0*10.0
const DASH_IMPULSE = 1000.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity") # default default is 980

var last_direction: float = 0.0

var nearby_stars: Array[Star] = []
var nearest_star: Star = null
var angle_to_nearest_star: float = 0.0

@onready var machine: StateMachine = $StateMachine
@onready var dlabel: DebugLabel = $DebugLabel
@onready var dash_arrow: DashArrow = $DashArrow

func _ready() -> void:
	# Prep initial is_on_floor
	velocity = Vector2.ZERO
	move_and_slide()

func _physics_process(_delta: float) -> void:
	dlabel.update_line(0, str("State: ", machine.state.name))
	dlabel.update_line(1, str(gravity))
	#print(nearby_stars)
	update_nearest_star()
	update_arrow()

func get_input_direction() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")

	# I do not like this here
	#if last_direction != direction and direction != 0:
		#update_sprites(direction)

	last_direction = direction
	return direction

func reset_gravity() -> void:
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func update_arrow() -> void:
	if nearest_star == null:
		dash_arrow.visible = false
	else:
		dash_arrow.visible = true
		dash_arrow.set_rotation(angle_to_nearest_star)

func update_nearest_star() -> void:
	var closest_star: Star
	var closest_delta: float = 1e9
	var delta: float = 0.0
	for star in nearby_stars:
		delta = self.global_position.distance_squared_to(star.global_position)
		if delta < closest_delta:
			closest_delta = delta
			closest_star = star

	# To me it makes sense to first find the closest star and then set everything afterwards
	# Instead of reusing the vars
	if closest_star == null:
		nearest_star = null
	else:
		nearest_star = closest_star		# Pardon the similar naming
		angle_to_nearest_star = self.global_position.angle_to_point(closest_star.global_position)

func has_nearest_star() -> bool:
	if nearest_star == null:
		return false
	return true

func forget_star(star: Star) -> void:
	nearby_stars.erase(star)

func _on_star_collider_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	var parent: Star = area.get_parent() as Star
	if parent is Star and parent.is_corrupted(): # or != null?
		nearby_stars.append(parent)

func _on_star_collider_area_shape_exited(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	var parent: Star = area.get_parent() as Star
	if parent is Star:
		nearby_stars.erase(parent)
