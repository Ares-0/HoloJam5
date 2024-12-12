class_name World extends Node2D

# World is a sequence of levels/rooms
# All the levels/rooms?

@export var current_room: Room
@export var room_index: int = 0

var room_list: Array[String]
var room_count: int = 0

@onready var player: Player = $Gloom
@onready var anim_player: AnimationPlayer = $FadeAnimationPlayer
@onready var hallway: Node2D = $Hallway
@onready var camera: GameCamera = $Camera2D

func _ready() -> void:
	var scene_path = get_tree().current_scene.scene_file_path
	assert(current_room != null, str("World ", scene_path, " does not have an inital room"))

	var test: int = GameState.loading_room_num
	if test > 0:
		room_index = test

	fill_room_list()
	current_room.room_exited.connect(_on_room_exited)
	current_room.enable()
	current_room.set_player(player)
	player.position = current_room.player_respawn_ref.position
	$ColorRect.visible = true

	if room_index >= 1:
		AudioManager.soundtrack_start()

	if room_index > 0:
		change_to_room(room_index)
	else:
		# New game setup
		player.movement_disable()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip_room"):
		room_index += 1
		if room_index >= room_count:
			exit_world()
		else:
			change_to_room(room_index)
	if Input.is_action_just_pressed("return_room"):
		room_index -= 1
		room_index = max(0, room_index)
		change_to_room(room_index)

func change_to_room(num: int) -> void:
	var num_fixed: int = num
	# Catch out of bounds error
	if num > room_list.size():
		push_error("Room number ", num, " doesn't exist")
		num_fixed = 1

	player.movement_disable()

	var tween = get_tree().create_tween()
	tween.tween_property(current_room, "modulate", Color.BLACK, 0.2)

	var next_scene = load(room_list[num_fixed])
	var next_room = next_scene.instantiate() as Room

	# Set up the new room
	next_room.room_exited.connect(_on_room_exited)
	next_room.set_player(player)
	next_room.modulate = Color.BLACK

	await tween.finished
	self.call_deferred("add_child", next_room)

	# Remove the old room
	$CanvasModulateTotal.visible = true # band aid
	current_room.queue_free()
	current_room = next_room

	# Player visual transition
	player.position -= Vector2(1000, 1000)
	camera.position -= Vector2(1000, 1000)
	hallway.visible = true
	hallway.position = player.position + Vector2.ONE
	camera.punch_in(1.0, Vector2(player.position.x, camera.position.y), 0.5)
	await camera.punched

	await get_tree().process_frame
	var diff = player.position - current_room.spawn_point
	player.position -= diff
	camera.position -= diff
	hallway.position -= diff

	#await get_tree().create_timer(0.5).timeout
	hallway.visible = false
	hallway.position = Vector2.ONE * -1000

	# Player should already be in final place by now
	center_camera_on_room()
	var tween2 = get_tree().create_tween()
	tween2.tween_property(current_room, "modulate", Color(0.5, 0.5, 0.5), 0.5)
	await tween2.finished

	current_room.enable()
	player.movement_enable()

	var tween3 = get_tree().create_tween()
	tween3.tween_property(current_room, "modulate", Color.WHITE, 0.5)
	await tween3.finished

func center_camera_on_room() -> void:
	camera.punch_in(current_room.camera_zoom, current_room.room_size * 0.5, 0.5)

func exit_world() -> void:
	# After final room, quit or show cutscene or something
	print("Game Over")
	get_tree().change_scene_to_file("res://source/gui/menus/title_screen.tscn")

func _on_room_exited() -> void:
	room_index += 1
	if room_index >= room_count:
		exit_world()
	else:
		change_to_room(room_index)

func fill_room_list() -> void:
	# This is just down here because I want it at the bottom of the file
	room_list = [
		"res://source/settings/rooms/practice_room_01.tscn",
		"res://source/settings/rooms/practice_room_02.tscn"
	]
	room_count = room_list.size()
