class_name OptionsMenu
extends Control

@onready var slider_master: HSlider = $AudioOptions/VBoxContainer/SliderMaster
@onready var slider_music: HSlider = $AudioOptions/VBoxContainer/SliderMusic
@onready var slider_sfx: HSlider = $AudioOptions/VBoxContainer/SliderSFX

var parent: PauseMenu = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_bus_values()

func get_bus_values() -> void:
	slider_master.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	slider_music.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	slider_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func open(calling_parent: PauseMenu) -> void:
	parent = calling_parent
	get_bus_values()

func _on_apply_button_pressed() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(slider_master.value))
	AudioServer.set_bus_volume_db(1, linear_to_db(slider_music.value))
	AudioServer.set_bus_volume_db(2, linear_to_db(slider_sfx.value))

func _on_slider_master_mouse_exited() -> void:
	release_focus()

func _on_slider_music_mouse_exited() -> void:
	release_focus()

func _on_slider_sfx_mouse_exited() -> void:
	release_focus()

func _on_close_button_pressed() -> void:
	if parent == null:
		get_tree().quit()
	else:
		parent.return_from_options()

func _on_slider_master_drag_ended(_value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(slider_master.value))

func _on_slider_music_drag_ended(_value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(slider_music.value))

func _on_slider_sfx_drag_ended(_value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(slider_sfx.value))
