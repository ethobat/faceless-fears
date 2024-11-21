extends Control
class_name EntityPanelGrid

const ENTITY_PANEL = preload("res://scenes/ui/entity_panel.tscn")

@export var show_slot_numbers: bool = false

func update(entities: Array[Entity], counts: Array[int]):
	for child in get_children():
		child.queue_free()
	for i in range(len(entities)):
		var slot = ENTITY_PANEL.instantiate()
		slot.entity = entities[i]
		slot.count = counts[i]
		slot.slot_number = i + 1
		slot.show_slot_number = show_slot_numbers
		add_child(slot)
