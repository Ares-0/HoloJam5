class_name DebugLabel extends Control

# Just a handy tool for showing debug info above an actor
# Lines count upward, so line 0 on the bottom and line N on the top

var lines: Array[String] = [""]

@onready var label: Label = $Label

func _process(_delta: float) -> void:
	label.text = ""
	for element in lines:
		label.text = str("\n", element) + label.text

func update_line(num: int, text: String) -> void:
	check_size(num)
	lines[num] = text

func check_size(num: int) -> void:
	if lines.size() >= num + 1:
		return
	while(lines.size() <= num):
		lines.append("")
