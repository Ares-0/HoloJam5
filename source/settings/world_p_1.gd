extends World

func fill_room_list() -> void:
	# This is just down here because I want it at the bottom of the file
	room_list = [
		"res://source/settings/rooms/p1/r1.tscn", # jump and move right
		"res://source/settings/rooms/p1/r2.tscn", # jump over pits
		"res://source/settings/rooms/p1/r3.tscn", # dash over large pits
		"res://source/settings/rooms/p1/r4.tscn", # dash up (and down)
		"res://source/settings/rooms/p1/r5.tscn", # need to cleanse stars to exit
		"res://source/settings/rooms/p1/r6.tscn", # stars can have multiple charges

		"res://source/settings/rooms/p2/d1.tscn",
		"res://source/settings/rooms/p2/d2.tscn",
		"res://source/settings/rooms/p2/d3.tscn",
		"res://source/settings/rooms/p2/d4.tscn",
		"res://source/settings/rooms/p2/d5.tscn",
		"res://source/settings/rooms/p2/d6.tscn",
	]
	room_count = room_list.size()
