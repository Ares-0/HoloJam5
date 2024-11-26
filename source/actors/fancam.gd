extends Camera2D

@export var player_ref: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.position = player_ref.position + Vector2(0, -50)

	var zoom_next: Vector2 = self.zoom
	if Input.is_action_just_pressed("debug_zoom_in"):
		zoom_next += Vector2.ONE * 0.05
	if Input.is_action_just_pressed("debug_zoom_out"):
		zoom_next -= Vector2.ONE * 0.05
	zoom_next = zoom_next.max(Vector2(0.1, 0.1))

	# dont set til the end
	if self.zoom != zoom_next:
		self.zoom = zoom_next
		# print(zoom_next)
