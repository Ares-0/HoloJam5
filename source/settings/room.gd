class_name Room extends Node2D

# brainstorming for now
# Order of rooms is linear
# rooms have an Area2D "Entrance"
# When player hits this (from another room), transition to owning room begins
#    Alternatively, could make each room have an "exit"
#		I bet this way has fewer collisions in world layout
#
# Entering new room means:
#	loading the room? the next room?
#	resizing the camera
#	player moving to position
#	fade old room to black, zoom camera/player to position, fade new room in from black
#
# These rooms should have really basic initial states that fully describe them
# Player starting location
# If stars are on or not

signal room_exited

@export var player: Player
@export var room_size: Vector2
@export var camera_zoom: float

var room_enabled: bool = false # if false, some room elements are disabled or not ready

# Initial state stuff
var spawn_point: Vector2
var stars_list: Array[Star] = []
var stars_state_list: Array[int] = []

@onready var player_respawn_ref: Node2D = $PlayerRespawn
@onready var exit_ref: RoomExit = $RoomExit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene_path = get_tree().current_scene.scene_file_path
	assert(player_respawn_ref != null, str("Level ", scene_path, " does not have a player spawn point"))
	assert(exit_ref != null, str("Level ", scene_path, " does not have an exit"))
	assert(camera_zoom != 0, str("Level ", scene_path, " zoom not set"))
	assert(room_size != Vector2.ZERO, str("Level ", scene_path, " size not set"))

	exit_ref.exit_entered.connect(_on_room_exit_exit_entered)
	capture_initial_state()
	
	exit_ref.deactivate()
	check_door()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quick_reset"): # todo: only active room, somehow
		reset()

	check_door() # this doesn't have to be every frame

func set_player(p: Player) -> void:
	player = p

func capture_initial_state() -> void:
	# I want to do this this way because these are simple rooms
	# I dont want to unload and reload them, would rather just reset a few values
	spawn_point = player_respawn_ref.position
	for child in get_children():
		if child is Star:
			stars_list.append(child)
			stars_state_list.append(child.charges)

func reset() -> void:
	player.position = spawn_point
	for idx in range(0, stars_list.size()):
		stars_list[idx].set_charges(stars_state_list[idx])
	exit_ref.deactivate()
	check_door()

func enable():
	room_enabled = true

func check_door() -> void:
	var all_clean: bool = true
	for star in stars_list:
		if not star.clean:
			all_clean = false
			break
	if all_clean:
		exit_ref.activate()

func _on_room_exit_exit_entered() -> void:
	if room_enabled:
		room_exited.emit()

func _on_killzone_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		reset()
