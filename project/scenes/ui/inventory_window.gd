extends Control
class_name InventoryWindow

@onready var entity_panel_grid: EntityPanelGrid = $ItemsBG/EntityPanelGrid

func update(entities: Array, counts: Array):
	entity_panel_grid.update(entities, counts)
