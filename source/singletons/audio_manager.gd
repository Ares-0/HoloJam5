extends Node

# Autoload singelton that plays the music and sound effects of the game

func _ready() -> void:
	print("audio")

func _process(_delta: float) -> void:
	pass
	# if Input.is_action_just_pressed("debug_01"):
	# 	play("Sound2")
	# if Input.is_action_just_pressed("debug_02"):
	# 	play("Sound3")

func play(sfx: NodePath):
	get_node(sfx).play()
