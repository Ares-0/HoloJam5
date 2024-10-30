extends World

func fill_room_list() -> void:
	# This is just down here because I want it at the bottom of the file
	room_list = [
		"res://source/settings/intro_cutscene.tscn", # cutscene
		"res://source/settings/rooms/p1/a1.tscn", # jump and move right
		"res://source/settings/rooms/p1/a2.tscn", # jump over pits
		"res://source/settings/rooms/p1/a3.tscn", # dash over large pits
		"res://source/settings/rooms/p1/a4.tscn", # dash up (and down)
		"res://source/settings/rooms/p1/a5.tscn", # need to cleanse stars to exit
		"res://source/settings/rooms/p1/a6.tscn", # stars can have multiple charges

		"res://source/settings/rooms/p2/d1.tscn",
		"res://source/settings/rooms/p2/d2.tscn",
		"res://source/settings/rooms/p2/d3.tscn",
		"res://source/settings/rooms/p2/d4.tscn",
		"res://source/settings/rooms/p2/d5.tscn",
		"res://source/settings/rooms/p2/d6.tscn",

		"res://source/settings/rooms/p2/d7.tscn",
		"res://source/settings/rooms/p2/d8.tscn",
	]
	room_count = room_list.size()
