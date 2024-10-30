extends PlayerState

func enter(_old_state: String, _msg := {}) -> void:
	player.animation_player.play("rest")

func physics_update(_delta: float) -> void:
	if player.get_input_direction() != 0.0:
		finished.emit("Idle")
	if Input.is_action_just_pressed("dash"):
		if player.has_nearest_star():
			finished.emit("Dash")
