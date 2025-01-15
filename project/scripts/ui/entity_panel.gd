extends Control
class_name EntityPanel

var is_empty: bool = false

@export var highlight_on_mouseover: bool = true
@export var show_count_label = true
@export var show_slot_number = false

@onready var svc: SubViewportContainer = $SubViewportContainer
@onready var camera: Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var model_holder: Node3D = $SubViewportContainer/SubViewport/ModelHolder

var model: Node3D
var model_scale_orig: Vector3
var model_rot_y_orig: float

# Inventory slot stuff
# ---
var is_inventory_slot:
	get:
		return inventory_window != null
var inventory:
	get:
		return inventory_window.inventory_entity
var inventory_window: InventoryWindow
# ---

func _ready():
	if highlight_on_mouseover:
		mouse_entered.connect(func(): highlighted = true)
		mouse_exited.connect(func(): highlighted = false)
	$CountLabel.visible = show_count_label
	$SlotNumberLabel.visible = show_slot_number
	$Label.visible = show_label

func _physics_process(delta):
	if highlighted:
		if model == null:
			print("uh oh")
		model.rotation.y += 1 * delta

func _on_visibility_changed():
	pass

func try_take_all() -> Event:
	return inventory.fire_event("try_remove_item", [entity, count, 0])

func try_take(n: int) -> Event:
	return inventory.fire_event("try_remove_item", [entity, n, 0])

# This gets called before onready variables are set
func clear_model():
	var mh = $SubViewportContainer/SubViewport/ModelHolder
	if mh.get_child_count() > 0:
		mh.get_child(0).queue_free()

func update():
	inventory_window.update()

var entity: Entity:
	set(value):
		entity = value
		if entity == null:
			$Label.text = "NULL"
			is_empty = true
			model = null
			highlighted = false
			clear_model()
		else:
			$Label.text = entity.resource_name
			is_empty = false
			clear_model()
			model = entity.instantiate_model()
			model.position = entity.slot_render_position
			model.rotation_degrees = entity.slot_render_rotation
			model.scale = Vector3(entity.slot_render_scale, entity.slot_render_scale, entity.slot_render_scale)
			model_scale_orig = model.scale
			model_rot_y_orig = entity.slot_render_rotation.y
			$SubViewportContainer/SubViewport/ModelHolder.add_child(model)

@export var show_label: bool = true:
	set(value):
		show_label = value
		$Label.visible = show_label
		
var count: int = 0:
	set(value):
		count = value
		var cl = $CountLabel
		var name_label = $Label
		if count < 0:
			cl.visible = false
			name_label.visible = false
		else:
			cl.visible = true
			name_label.visible = true
			cl.text = str(count)
		
var slot_number: int = 0:
	set(value):
		slot_number = value
		$SlotNumberLabel.text = str(slot_number)

var scale_tween: Tween

var highlighted: bool = false:
	set(value):
		if not highlighted and value: # highlight
			scale_tween = create_tween()
			scale_tween.set_trans(Tween.TRANS_QUAD)
			scale_tween.set_ease(Tween.EASE_OUT)
			scale_tween.tween_property(model, "scale", model_scale_orig * 1.3, 0.5)
		if highlighted and not value: # unhighlight
			if scale_tween != null:
				scale_tween.kill()
				if model != null:
					model.scale = model_scale_orig
		highlighted = value

func _on_gui_input(event: InputEvent):
	if event is InputEventMouse and is_inventory_slot:
		var cursor: Cursor = get_tree().get_first_node_in_group("cursor")
		if Input.is_action_just_pressed("use"): # left click
			cursor.on_inventory_slot_clicked(self)
		elif Input.is_action_just_pressed("alt_use"):
			cursor.on_inventory_slot_right_clicked(self)

