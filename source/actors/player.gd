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
const TILT_IMPULSE: float = 700

var gravity: float = BASE_GRAVITY

var last_direction: float = 0.0
var facing_right: bool = true
var movement_enabled: bool = true

#var nearby_stars: Array[Star] = []
var nearest_star: Star = null
var angle_to_nearest_star: float = 0.0
var is_overlapping_star: bool = false

var TILT_CHARGES_MAX: int = 1
var tilt_charges: int = 0

@onready var machine: StateMachine = $StateMachine
@onready var dlabel: DebugLabel = $DebugLabel
@onready var dash_arrow: DashArrow = $DashArrow
@onready var star_collider: Area2D = $StarCollider
@onready var audio_man_ref: Node = $"/root/AudioManager"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_sheet_R: Sprite2D = $SpriteSheetR
@onready var sprite_sheet_L: Sprite2D = $SpriteSheetL
@onready var light: PointLight2D = $PointLight2D

func _ready() -> void:
	tilt_charges = TILT_CHARGES_MAX
	# Prep initial is_on_floor # edit: or not
	velocity = Vector2.ZERO
	move_and_slide()
	update_arrow()

func _physics_process(_delta: float) -> void:
	dlabel.update_line(0, str("State: ", machine.state.name))
	dlabel.update_line(1, str(gravity))
	#print(nearby_stars)
	update_nearest_star()
	update_arrow()
	#print(is_overlapping_star)
	#update_sprites(last_direction)

	# if self.velocity.length() > 20:
	# 	print(self.velocity.length())
	# 	print(self.velocity)

func get_input_direction() -> float:
	if !movement_enabled:
		return 0.0

	# technically this is only x
	var direction: float = Input.get_axis("move_left", "move_right")

	# I do not like this here!
	if last_direction != direction and direction != 0:
		update_sprites(direction)

	last_direction = direction
	return direction

func update_sprites(direction: float) -> void:
	if direction > 0:
		facing_right = true
		animation_player.root_node = "../SpriteSheetR"
		sprite_sheet_R.visible = facing_right
		sprite_sheet_L.visible = !facing_right
	elif direction < 0:
		facing_right = false
		animation_player.root_node = "../SpriteSheetL"
		sprite_sheet_R.visible = facing_right
		sprite_sheet_L.visible = !facing_right

func reset_gravity() -> void:
	gravity = BASE_GRAVITY

func reset_state() -> void:
	machine._transition_to_next_state("Idle")

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
	is_overlapping_star = false
	for area in star_collider.get_overlapping_areas():
		if area.priority == 1:
			is_overlapping_star = true
			continue
		# priority is not 1
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

func turn_transparent(duration: float) -> void:
	if duration == 0.0:
		self.modulate = Color.TRANSPARENT
		light.energy = 0.0
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.TRANSPARENT, duration)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(light, "energy", 0.0, duration)

func turn_opaque(duration: float) -> void:
	if duration == 0.0:
		self.modulate = Color.WHITE
		light.energy = 0.5
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, duration)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(light, "energy", 0.5, duration)

func movement_disable() -> void:
	movement_enabled = false

func movement_enable() -> void:
	movement_enabled = true

func reset_tilt_charges() -> void:
	tilt_charges = TILT_CHARGES_MAX

func decrement_tilt_charge() -> void:
	if tilt_charges > 0:
		tilt_charges -= 1

func get_tilt_charges() -> int:
	return tilt_charges

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
