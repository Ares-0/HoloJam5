extends Node

# Handles saving and loading the game progress info, and any other
# globally needed data

var loading_room_num: int = 0
var pauser: PauseMenu = null

func _ready() -> void:
	print("ready to handle stuff")

func _process(_delta: float) -> void:
	pass
