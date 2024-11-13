class_name RoomExit extends Area2D

signal exit_entered

var active: bool = false # active means locked to player or not (via stars)
var disabled: bool = false # disabled means on or off (during room reset)
# disabled takes priority over active

@onready var scratches: AnimatedSprite2D = $AnimatedSprite2D

func activate() -> void:
	active = true
	scratches.visible = false

func deactivate() -> void:
	active = false
	scratches.visible = true

func enable() -> void:
	disabled = false

func disable() -> void:
	disabled = true

func _on_area_entered(area: Area2D) -> void:
	if disabled or not active:
		return
	if area.get_parent() is Player:
		exit_entered.emit()
