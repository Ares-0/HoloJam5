extends World

func fill_room_list() -> void:
	# This is just down here because I want it at the bottom of the file
	room_list = [
		# 0 - 6
		"res://source/settings/intro_cutscene.tscn", # cutscene
		"res://source/settings/rooms/p1/a1.tscn", # jump and move right
		"res://source/settings/rooms/p1/a2.tscn", # jump over pits
		"res://source/settings/rooms/p1/a3.tscn", # dash over large pits
		"res://source/settings/rooms/p1/a4.tscn", # dash up (and down)
		"res://source/settings/rooms/p1/a5.tscn", # need to cleanse stars to exit / hold for distance
		"res://source/settings/rooms/p1/a6.tscn", # stars can have multiple charges

		# 7 - 14
		"res://source/settings/rooms/p2/d1.tscn", # fine
		"res://source/settings/rooms/p2/d2.tscn", # fine
		"res://source/settings/rooms/p2/d3.tscn", # harder than it looks
		"res://source/settings/rooms/p2/d4.tscn", # tilt tutorial
		"res://source/settings/rooms/p2/d5.tscn", # wall tech tutorial, kinda tricky
		"res://source/settings/rooms/p2/d6.tscn", # fine, shows different star strengths
		"res://source/settings/rooms/p2/d7.tscn", # eh
		"res://source/settings/rooms/p2/d8.tscn", # fine

		# 15 - 
		"res://source/settings/rooms/p3/g1.tscn", # fine
		"res://source/settings/rooms/p3/g2.tscn", # decent
		"res://source/settings/rooms/p3/g3.tscn", # decent
		"res://source/settings/rooms/p3/g4.tscn", # decent
		"res://source/settings/rooms/p3/g5.tscn", # eh

	]
	room_count = room_list.size()
