extends World

func fill_room_list() -> void:
	# This is just down here because I want it at the bottom of the file
	room_list = [
		"res://source/settings/rooms/p1/r1.tscn",
		"res://source/settings/rooms/p1/r2.tscn",
		"res://source/settings/rooms/p1/r3.tscn",
		"res://source/settings/rooms/p1/r4.tscn",
		"res://source/settings/rooms/p2/d1.tscn",
		"res://source/settings/rooms/p2/d2.tscn",
		"res://source/settings/rooms/p2/d3.tscn",
		"res://source/settings/rooms/p2/d4.tscn",
	]
	room_count = room_list.size()
