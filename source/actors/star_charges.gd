class_name StarCharges extends Node2D

var charges: Array[StarCharge] = []
var charge_resource: Resource = preload("res://source/actors/star_charge.tscn")

func set_charges(val: int) -> void:
	var diff: int = val - charges.size()
	if diff == 0:
		return
	if diff < 0:
		for i in range(0, -diff):
			decrement_charge()
	if diff > 0:
		for i in range(0, diff):
			increment_charge()

func increment_charge() -> void:
	var new_charge: StarCharge = charge_resource.instantiate()
	self.add_child(new_charge)
	new_charge.rotate(randf_range(0.0, 2*PI))
	charges.append(new_charge)
	update_rots()
	charges.shuffle()

func decrement_charge() -> void:
	if charges.size() == 0:
		return

	var old: StarCharge = charges.pop_back()
	old.deactivate()
	await old.moved
	old.queue_free()
	update_rots()
	charges.shuffle()

func update_rots() -> void:
	var count: int = charges.size()
	for i in range(0, count):
		charges[i].rotate_to(2*PI / count * i)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", self.rotation+randf_range(-PI/2, PI/2), 0.15)

func rng_whole_rotate() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation", self.rotation+randf_range(-PI, PI), 0.15)
