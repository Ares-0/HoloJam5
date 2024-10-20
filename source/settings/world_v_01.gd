extends Node2D

@export var current_room: Room

var room_index: int = 0
var room_list: Array[String]
var room_count: int = 0

@onready var player: Player = $Gloom

func _ready() -> void:
	fill_room_list()
	current_room.room_exited.connect(_on_room_exited)

func _process(_delta: float) -> void:
	pass

func change_to_room(num: int) -> void:
	# Catch out of bounds error
	var next_scene = load(room_list[num])
	var instance = next_scene.instantiate() as Room
	self.call_deferred("add_child", instance)

	# Set up the new room
	instance.room_exited.connect(_on_room_exited)
	instance.set_player(player)

	# Remove the old room
	current_room.queue_free()
	current_room = instance
	# might need to add some frame waits around here

func fill_room_list() -> void:
	# This is just down here because I want it at the bottom of the file
	room_list = [
		"res://source/settings/practice_room_01.tscn",
		"res://source/settings/empty_room.tscn",
		"res://source/settings/practice_room_01.tscn"
	]
	room_count = room_list.size()

func exit_world() -> void:
	# After final room, quit or show cutscene or something
	print("Game Over")
	get_tree().quit()

func _on_room_exited() -> void:
	room_index += 1
	if room_index >= room_count:
		exit_world()
	else:
		change_to_room(room_index)
