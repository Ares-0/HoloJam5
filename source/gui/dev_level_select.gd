extends Control

func _on_debug_b_pressed() -> void:
	get_tree().change_scene_to_file("res://source/settings/rooms/dev_room.tscn")


func _on_world_b_pressed() -> void:
	get_tree().change_scene_to_file("res://source/settings/world_p1.tscn")
