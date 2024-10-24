class_name Player
extends CharacterBody2D

const SPEED: float = 400.0 # really should be max speed
const AIR_SPEED: float = 400.0
const JUMP_IMPULSE: float = -650.0
const ACCELERATION: float = 60.0*60.0 # per second aka per 60 frames, so N is delta per frame
const FRICTION: float = 60.0*55.0 # high friction = greater deceleration
const AIR_FRICTION: float = 60.0*15.0
const DASH_IMPULSE: float = 900.0
const BASE_GRAVITY: float = 980.0*1.6

var gravity: float = BASE_GRAVITY

var last_direction: float = 0.0

#var nearby_stars: Array[Star] = []
var nearest_star: Star = null
var angle_to_nearest_star: float = 0.0

@onready var machine: StateMachine = $StateMachine
@onready var dlabel: DebugLabel = $DebugLabel
@onready var dash_arrow: DashArrow = $DashArrow
@onready var star_collider: Area2D = $StarCollider

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
	
	# if self.velocity.length() > 20:
	# 	print(self.velocity.length())

func get_input_direction() -> float:
	# technically this is only x
	var direction: float = Input.get_axis("move_left", "move_right")

	# I do not like this here
	#if last_direction != direction and direction != 0:
		#update_sprites(direction)

	last_direction = direction
	return direction

func reset_gravity() -> void:
	gravity = BASE_GRAVITY

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
	for area in star_collider.get_overlapping_areas():
		if not area.monitorable:
			continue
		var star: Star = area.get_parent() as Star
		if star == null:
			continue
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

func get_directional_influence() -> Vector2:
	var direction_x: float = Input.get_axis("move_left", "move_right")
	var direction_y: float = Input.get_axis("move_up", "move_down")

	var last: Vector2 = Vector2(direction_x, direction_y)
	return last.normalized()

func has_nearest_star() -> bool:
	if nearest_star == null:
		return false
	return true

func end_dash() -> void:
	if machine.state.name == "Dash":
		machine._transition_to_next_state("Air")

func _on_star_collider_area_shape_entered(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	pass
	#var parent: Star = area.get_parent() as Star
	#if parent is Star and parent.is_corrupted(): # or != null?
		#nearby_stars.append(parent)

func _on_star_collider_area_shape_exited(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	pass
	#var parent: Star = area.get_parent() as Star
	#if parent is Star:
		#nearby_stars.erase(parent)
