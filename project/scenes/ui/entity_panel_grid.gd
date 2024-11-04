extends Control
class_name EntityPanelGrid

const ENTITY_PANEL = preload("res://scenes/ui/entity_panel.tscn")

func update(items: Dictionary):
	for child in get_children():
		child.queue_free()
	for entity in items:
		var slot = ENTITY_PANEL.instantiate()
		slot.entity = entity
		add_child(slot)
