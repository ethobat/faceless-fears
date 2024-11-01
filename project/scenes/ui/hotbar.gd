extends HBoxContainer

const ENTITY_PANEL = preload("res://scenes/ui/entity_panel.tscn")

@export var inv: Inventory

func _ready():
	rebuild()

func rebuild():
	for child in get_children():
		child.queue_free()
	for entity in inv.items:
		var slot = ENTITY_PANEL.instantiate()
		slot.entity = entity
		add_child(slot)
