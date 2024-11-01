extends Node

# Autoload singelton that plays the music and sound effects of the game

func _ready() -> void:
	print("audio ready")
	#soundtrack_start()

func _process(_delta: float) -> void:
	pass

func soundtrack_start() -> void:
	$OST_Main.play()

func soundtrack_stop() -> void:
	$OST_Main.stop()

func play(sfx: NodePath):
	var sound_node = get_node_or_null(sfx)
	assert(sound_node != null, str("Sound ", sfx, " does not exist"))
	sound_node.play()

func stop(sfx: NodePath):
	var sound_node = get_node_or_null(sfx)
	assert(sound_node != null, str("Sound ", sfx, " does not exist"))
	sound_node.stop()
