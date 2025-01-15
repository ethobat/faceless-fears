extends Control
class_name InventoryWindow

@onready var entity_panel_grid: EntityPanelGrid = $ItemsBG/EntityPanelGrid

var inventory_entity: Entity:
	set(value):
		inventory_entity = value
		entity_panel_grid.set_inventory_entity(inventory_entity)

func update():
	var items = inventory_entity.get_items()
	entity_panel_grid.update(items.keys(), items.values(), self)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouse:
		var cursor: Cursor = get_tree().get_first_node_in_group("cursor")
		if Input.is_action_just_pressed("use"): # left click
			cursor.on_inventory_clicked(self)
		elif Input.is_action_just_pressed("alt_use"):
			cursor.on_inventory_right_clicked(self)
