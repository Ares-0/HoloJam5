class_name TitleScreen
extends Control

@onready var VersionL: Label = $VersionLabel
@onready var newgame_B: Button = $"MarginContainer/VBoxContainer/HBoxContainer/MenuActions/New Game"
@onready var continue_B: Button = $MarginContainer/VBoxContainer/HBoxContainer/MenuActions/Continue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# VersionL.text = "v" + StateManager.version_number
	pass
	newgame_B.grab_focus()

func _on_new_game_pressed() -> void:
	# todo: fade to black before changing
	get_tree().change_scene_to_file("res://source/settings/world_p1.tscn")

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://source/gui/menus/room_select.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://source/gui/menus/credits.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	$BlackScreen.visible = true
	get_tree().quit()
