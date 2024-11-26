class_name PauseMenu
extends Control

var paused: bool = false

@onready var resume_button: Button = $PauseMenuUI/CenterContainer/VBoxContainer/ResumeB

func _ready() -> void:
	GameState.pauser = self

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if paused:
			unpause()
		else:
			pause()

func pause() -> void:
	paused = true
	get_tree().paused = true
	resume_button.grab_focus()
	show()

func unpause() -> void:
	$PauseMenuUI.visible = true
	$OptionsMenu.visible = false
	paused = false
	hide()
	get_tree().paused = false

func _on_resume_b_pressed() -> void:
	unpause()

func _on_menu_b_pressed() -> void:
	paused = false
	# StateManager.return_to_menu_prep()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://source/gui/menus/title_screen.tscn")

func _on_options_b_pressed() -> void:
	$PauseMenuUI.visible = false
	$OptionsMenu.visible = true
	$OptionsMenu.open(self)

func return_from_options() -> void:
	$PauseMenuUI.visible = true
	$OptionsMenu.visible = false
