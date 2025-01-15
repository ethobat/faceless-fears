extends Resource
class_name Entity

# If false, the item will be rendered in the hand while selected in the hotbar, and the player can right-click to use the item.
# If true, the item will instead render as a ghost in-world while selected, and the player can right-click to place it.
@export var placeable: bool = false

@export var components: Array[Component] = []

@export var slot_render_position: Vector3 = Vector3.ZERO
@export var slot_render_rotation: Vector3 = Vector3.ZERO
@export var slot_render_scale: float = 1

func handle_event(event: Event) -> Event:
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
	return load("res://scenes/entities/"+self.resource_name+".tscn")
	
func get_model_scene() -> PackedScene:
	return load("res://scenes/entities/"+self.resource_name+"_model.tscn")
	
func get_ghost_scene() -> PackedScene:
	return load("res://scenes/entities/"+self.resource_name+"_ghost.tscn")
	
func physicalize() -> PhysicalEntity:
	var pe = get_physical_entity_scene().instantiate()
	pe.entity = self
	fire_event("physicalized", [pe])
	return pe
	
func instantiate_model() -> Node3D:
	return get_model_scene().instantiate()

func instantiate_ghost() -> Node3D:
	return get_ghost_scene().instantiate()
	
	
###########################################
## "Shorthand" methods for firing events ##
###########################################

func get_items() -> Dictionary:
	return fire_event("get_items", [{}]).values[0]

########################################
