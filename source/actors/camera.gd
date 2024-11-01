class_name GameCamera extends Camera2D

signal punched

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	var zoom_next: Vector2 = self.zoom
	# if Input.is_action_just_pressed("debug_zoom_in"):
	# 	zoom_next += Vector2.ONE * 0.05
	# if Input.is_action_just_pressed("debug_zoom_out"):
	# 	zoom_next -= Vector2.ONE * 0.05
	zoom_next = zoom_next.max(Vector2(0.1, 0.1))

	# dont set til the end
	if self.zoom != zoom_next:
		self.zoom = zoom_next
		print(zoom_next)

func punch_in(zoom_lvl: float, pos: Vector2, duration: float) -> void:
	# center on location and with particular zoom
	var tweenZ = get_tree().create_tween()
	tweenZ.tween_property(self, "zoom", Vector2(zoom_lvl, zoom_lvl), duration)
	var tweenP = get_tree().create_tween()
	tweenP.tween_property(self, "position", pos, duration)
	await(tweenZ.finished)
	punched.emit()
