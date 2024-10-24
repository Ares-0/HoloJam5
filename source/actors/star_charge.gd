class_name StarCharge extends Node2D

signal moved

var active: bool = true

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if active:
		activate()
	else:
		deactivate()

func _process(_delta: float) -> void:
	pass

func move_indicator(loc: Vector2) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "position", loc, 0.2)
	await tween.finished
	moved.emit()

func swap() -> void:
	if active:
		deactivate()
	else:
		activate()

func activate() -> void:
	move_indicator(Vector2(0, -60))
	active = true

func deactivate() -> void:
	move_indicator(Vector2(0, 0))
	active = false

func rotate_to(value: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", value, 0.15)
