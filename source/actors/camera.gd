extends Camera2D

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	var zoom_next: Vector2 = self.zoom
	if Input.is_action_just_pressed("debug_zoom_in"):
		zoom_next += Vector2.ONE * 0.05
	if Input.is_action_just_pressed("debug_zoom_out"):
		zoom_next -= Vector2.ONE * 0.05
	zoom_next = zoom_next.max(Vector2(0.1, 0.1))
	# dont set til the end
	self.zoom = zoom_next
