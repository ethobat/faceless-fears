extends Control
class_name Cursor

@onready var entity_panel: EntityPanel = $CursorEntityPanel
@onready var tooltip_panel: Panel = $TooltipPanel
@onready var tooltip: Label = $Tooltip

@export var tooltip_margin: Vector2 = Vector2(8,8)

var displaying_tooltip: bool = false

# workaround for weird behavior where two clicks are detected at one for some reason
var clicked_this_frame: bool = false

func _ready():
	clicked_this_frame = false
	hide_tooltip()
	update_panel()

func _physics_process(_delta):
	clicked_this_frame = false
	position = get_global_mouse_position()

### TODO
func on_inventory_slot_clicked(target_slot: EntityPanel):
	if clicked_this_frame: return
	clicked_this_frame = true
	if entity_panel.entity == null and target_slot.entity != null:
		var take = target_slot.try_take_all()
		print(take.values)
		if take.values[2] >= 0:
			entity_panel.entity = take.values[0]
			entity_panel.count = take.values[2]
		update_panel()
		target_slot.update()

func on_inventory_slot_right_clicked(target_slot: EntityPanel):
	if clicked_this_frame: return
	clicked_this_frame = true
	if entity_panel.entity == null and target_slot.entity != null:
		var take = target_slot.try_take(1)
		if take.values[2] == 1:
			entity_panel.entity = take.values[0]
			entity_panel.count = take.values[2]
		update_panel()
		target_slot.update()

func on_inventory_clicked(inv_window: InventoryWindow):
	if clicked_this_frame: return
	clicked_this_frame = true
	if entity_panel.entity != null:
		var put = inv_window.inventory_entity.fire_event("try_add_item", [entity_panel.entity, entity_panel.count])
		entity_panel.count = put.values[1]
		update_panel()
		inv_window.update()
	
func on_inventory_right_clicked(inv_window: InventoryWindow):
	if clicked_this_frame: return
	clicked_this_frame = true
	if entity_panel.entity != null:
		var put = inv_window.inventory_entity.fire_event("try_add_item", [entity_panel.entity, 1])
		if put.values[1] == 0:
			entity_panel.count -= put.values[1]
		update_panel()
		inv_window.update()

func update_panel():
	if entity_panel.count == 0:
		entity_panel.entity = null
	entity_panel.visible = entity_panel.entity != null
	entity_panel.highlighted = entity_panel.visible

func show_tooltip(text: String):
	# only update tooltip if it's not already being displayed
	if not tooltip.visible:
		tooltip_panel.visible = true
		tooltip.visible = true
		tooltip.text = text

func resize_tooltip_panel():
	if tooltip_panel == null: return
	tooltip_panel.size = tooltip.size + tooltip_margin
	tooltip_panel.position = Vector2(-tooltip_margin.x/2,tooltip_margin.y/2-tooltip_panel.size.y)

func hide_tooltip():
	tooltip_panel.visible = false
	tooltip.visible = false
