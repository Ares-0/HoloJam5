extends Control

@export var num: int = 1

func _ready() -> void:
	$CenterContainer/Button.text = str(" %02d " % num)

func _on_button_pressed() -> void:
	$"/root/GameState".loading_room_num = num
	get_tree().change_scene_to_file("res://source/settings/world_p1.tscn")
