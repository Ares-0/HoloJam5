extends Control

#@onready var world_ref: World = 

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	pass

func _on_dev_room_pressed() -> void:
	get_tree().change_scene_to_file("res://source/settings/rooms/dev_room.tscn")

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://source/gui/menus/title_screen.tscn")
