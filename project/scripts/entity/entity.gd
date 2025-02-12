extends Resource
class_name Entity

# If false, the item will be rendered in the hand while selected in the hotbar, and the player can right-click to use the item.
# If true, the item will instead render as a ghost in-world while selected, and the player can right-click to place it.
@export var placeable: bool = false

@export var components: Array[Component] = []

@export var slot_render_position: Vector3 = Vector3.ZERO
@export var slot_render_rotation: Vector3 = Vector3.ZERO
@export var slot_render_scale: float = 1

@export var hand_position: Vector3 = Vector3.ZERO
@export var hand_rotation: Vector3 = Vector3.ZERO

func handle_event(event: Event) -> Event:
	if len(components) == 0: return event
	for component in components:
		component.handle_event(self, event)
	return event
	
func fire_event(event_type: String, values: Array) -> Event:
	var event = Event.new()
	event.event_type = event_type
	event.values = values
	return handle_event(event)

func equals(en: Entity):
	if len(components) != len(en.components):
		return false
	for i in range(len(components)):
		var ca = components[i]
		var cb = en.components[i]
		if not ca.get_script() == cb.get_script():
			return false
		if not components[i].equals(en.components[i]):
			return false
	return true

func get_physical_entity_scene() -> PackedScene:
	var path = "res://scenes/entities/"+self.resource_name+".tscn"
	var scene = load(path)
	assert(scene != null, "Couldn't find physical entity scene at "+path)
	return scene
	
func get_model_scene() -> PackedScene:
	var path = "res://scenes/entities/"+self.resource_name+"_model.tscn"
	var scene = load(path)
	assert(scene != null, "Couldn't find entity model scene at "+path)
	return scene
	
func get_ghost_scene() -> PackedScene:
	var path = "res://scenes/entities/"+self.resource_name+"_ghost.tscn"
	var scene = load(path)
	assert(scene != null, "Couldn't find entity ghost scene at "+path)
	return scene
	
func physicalize() -> PhysicalEntity:
	var pe = get_physical_entity_scene().instantiate()
	pe.entity = self
	fire_event("physicalized", [pe])
	return pe
	
func instantiate_model() -> Node3D:
	return get_model_scene().instantiate()

func instantiate_ghost() -> Node3D:
	return get_ghost_scene().instantiate()
	
func add_component(comp: Component):
	components.append(comp)
	comp.on_add(self)
	
func remove_first_component_of_type(type) -> Component:
	for i in range(len(components)):
		if is_instance_of(components[i], type):
			var comp = components[i]
			comp.on_remove(self)
			components.remove_at(i)
			return comp
	return null
	
###########################################
## "Shorthand" methods for firing events ##
###########################################

func get_items() -> Dictionary:
	return fire_event("get_items", [{}]).values[0]

########################################
