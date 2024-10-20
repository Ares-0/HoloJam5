extends Camera2D

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_zoom_in"):
		self.zoom += Vector2.ONE * 0.05
	if Input.is_action_just_pressed("debug_zoom_out"):
		self.zoom -= Vector2.ONE * 0.05
