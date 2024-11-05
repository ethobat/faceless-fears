extends Control
class_name InventoryWindow

@onready var entity_panel_grid: EntityPanelGrid = $ItemsBG/EntityPanelGrid

func update(items: Dictionary):
	entity_panel_grid.update(items)
