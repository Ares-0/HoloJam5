class_name Star extends Node2D

@export var clean: bool = false
@export var always_on: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var near_shape: Area2D = $NearbyShape

func _ready() -> void:
	if clean:
		cleanse()
	else:
		corrupt()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_01"):
		flip()

func is_corrupted() -> bool:
	return not clean

func flip() -> void:
	if clean:
		corrupt()
		clean = false
	else:
		cleanse()
		clean = true

func corrupt() -> void:
	sprite.set_modulate(Color.BLACK)
	near_shape.set_deferred("monitorable", true)
	near_shape.visible = true

func cleanse() -> void:
	sprite.set_modulate(Color.WHITE)
	near_shape.set_deferred("monitorable", false)
	near_shape.visible = false

func _on_overlap_shape_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		if not always_on:
			self.cleanse()
			area.get_parent().forget_star(self)
