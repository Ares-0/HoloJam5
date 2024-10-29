class_name Credits
extends Control

func _ready() -> void:
	$MenuButton.grab_focus()

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://source/gui/menus/title_screen.tscn")
