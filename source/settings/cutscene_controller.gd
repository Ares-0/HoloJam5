extends AnimationPlayer

# This script will control/animate everything else in the scene
# The room scene should just act like normal, clean the star then leave
# This will do all the other work

func _ready() -> void:
	await($"..".ready)
	$Camera2D.make_current()

	self.play("dark_in")
	await get_tree().create_timer(2.0).timeout
	AudioManager.play("Dark")

	await get_tree().create_timer(5.0).timeout
	$"..".player.movement_enable()

func _process(_delta: float) -> void:
	# if Input.is_action_just_pressed("debug_01"):
	# 	self.play("dark_in")
	if Input.is_action_just_pressed("dash"):
		AudioManager.stop("Dark")
		self.play("dark_out")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dark_out":
		await get_tree().create_timer(3.0).timeout
		self.play("camera_shift")
		AudioManager.soundtrack_start()
