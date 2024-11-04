extends Control
class_name InventoryWindow

@onready var entity_panel_grid: EntityPanelGrid = $EntityPanelGrid

func update(items: Dictionary):
	entity_panel_grid.update(items)
