class_name RoomExit extends Area2D

signal exit_entered

var active: bool = false

@onready var scratches: AnimatedSprite2D = $AnimatedSprite2D

func activate() -> void:
	active = true
	scratches.visible = false

func deactivate() -> void:
	active = false
	scratches.visible = true

func _on_area_entered(area: Area2D) -> void:
	if not active:
		return
	if area.get_parent() is Player:
		exit_entered.emit()
