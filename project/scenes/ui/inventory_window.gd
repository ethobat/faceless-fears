extends Control
class_name InventoryWindow

@onready var entity_panel_grid: EntityPanelGrid = $ItemsBG/EntityPanelGrid

func update(entities: Array[Entity], counts: Array[int]):
	entity_panel_grid.update(entities, counts)
