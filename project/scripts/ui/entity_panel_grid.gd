extends Control
class_name EntityPanelGrid

const ENTITY_PANEL = preload("res://scenes/ui/inventory/entity_panel.tscn")

@export var show_slot_numbers: bool = false

func update(entities: Array, counts: Array, inventory_window: InventoryWindow = null):
	for child in get_children():
		child.queue_free()
	for i in range(len(entities)):
		var slot: EntityPanel = ENTITY_PANEL.instantiate()
		slot.entity = entities[i]
		slot.count = counts[i]
		slot.slot_number = i + 1
		slot.show_slot_number = show_slot_numbers
		slot.inventory_window = inventory_window
		add_child(slot)
		
func set_inventory_entity(en: Entity):
	for ch in get_children():
		ch.inventory = en
