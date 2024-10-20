class_name Star extends Area2D

enum shape {OVERLAP, NEAR}

@export var clean: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if clean:
		cleanse()
	else:
		corrupt()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_01"):
		flip()

func flip() -> void:
	if clean:
		corrupt()
		clean = false
	else:
		cleanse()
		clean = true

func corrupt() -> void:
	sprite.set_modulate(Color.BLACK)

func cleanse() -> void:
	sprite.set_modulate(Color.WHITE)


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_parent() is Player:
		self.cleanse()
