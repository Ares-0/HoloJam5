class_name RoomExit extends Area2D

signal exit_entered

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		exit_entered.emit()
