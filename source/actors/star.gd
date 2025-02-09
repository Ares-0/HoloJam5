class_name Star extends Node2D

@export var clean: bool = false
@export var always_on: bool = false
@export var charges: int = 1
@export var force_multiplier: float = 1.0
@export var color_adjust: Color = Color.WHITE

@onready var sprite: Sprite2D = $Sprite2D
@onready var near_shape: Area2D = $NearbyShape
@onready var over_shape: Area2D = $OverlapShape
@onready var light: PointLight2D = $Light
@onready var charge_indicator: StarCharges = $StarCharges
@onready var scratches: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	self.modulate = color_adjust
	if clean:
		cleanse()
	else:
		corrupt()
	scratches.frame = randi_range(0, 5)
	scratches.rotation_degrees = [0, 180][randi_range(0, 1)]
	charge_indicator.set_charges(charges-1)
	near_shape.priority = 0
	over_shape.priority = 1

func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("debug_01"):
		#set_charges(charges-1)
	#if Input.is_action_just_pressed("debug_02"):
		#set_charges(charges+1)
	$Label.text = str(charges)

func is_corrupted() -> bool:
	return not clean

func flip() -> void:
	if clean:
		corrupt()
	else:
		cleanse()

func corrupt() -> void:
	#sprite.set_modulate(Color.BLACK)
	near_shape.set_deferred("monitorable", true)
	over_shape.set_deferred("monitorable", true)
	near_shape.visible = true
	light.energy = 1.0
	light.scale = Vector2.ONE
	scratches.visible = true
	clean = false

func cleanse() -> void:
	sprite.set_modulate(Color.WHITE)
	near_shape.set_deferred("monitorable", false)
	over_shape.set_deferred("monitorable", false)
	near_shape.visible = false
	light.energy = 1.5
	light.scale = Vector2.ONE * 2.0
	scratches.visible = false
	clean = true

func charge_down() -> void:
	if charges > 0:
		charges -= 1
		charge_indicator.decrement_charge()
	if charges == 0:
		if not always_on:
			self.cleanse()

func set_charges(value: int) -> void:
	if value >= 0:
		charges = value
	else:
		charges = 0
	if charges == 0:
		cleanse()
	else:
		corrupt()
		charge_indicator.set_charges(value-1)
		charge_indicator.rng_whole_rotate()

func reset_shape() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(near_shape, "scale", Vector2(0.1, 0.1), 0.05)
	await tween.finished
	var tween2 = get_tree().create_tween()
	tween2.tween_property(near_shape, "scale", Vector2.ONE, 0.05)
	await tween2.finished

func _on_overlap_shape_area_entered(_area: Area2D) -> void:
	pass
	#var obj = area.get_parent()
	#if obj is Player:
		#if obj.get_recently_dashed():
			#charge_down()
			#obj.end_dash()
