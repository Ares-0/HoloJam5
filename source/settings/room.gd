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
#
# These rooms should have really basic initial states that fully describe them
# Player starting location
# If stars are on or not

@export var player: Player

# Initial state stuff
var spawn_point: Vector2
var stars_list: Array[Star] = []
var stars_state_list: Array[bool] = []

@onready var player_respawn_ref: Node2D = $PlayerRespawn
@onready var exit_ref: RoomExit = $RoomExit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene_path = get_tree().current_scene.scene_file_path
	assert(player_respawn_ref != null, str("Level ", scene_path, " does not have a player spawn point"))
	assert(exit_ref != null, str("Level ", scene_path, " does not have an exit"))
	
	# connect signals
	capture_initial_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quick_reset"): # todo: only active room, somehow
		reset()

func capture_initial_state() -> void:
	# I want to do this this way because these are simple rooms
	# I dont want to unload and reload them, would rather just reset a few values
	spawn_point = player_respawn_ref.position
	for child in get_children():
		if child is Star:
			stars_list.append(child)
			stars_state_list.append(child.clean)

func reset() -> void:
	player.position = spawn_point
	for idx in range(0, stars_list.size()):
		if stars_state_list[idx]:
			stars_list[idx].cleanse()
		else:
			stars_list[idx].corrupt()

func _on_room_exit_exit_entered() -> void:
	pass # Replace with function body.
