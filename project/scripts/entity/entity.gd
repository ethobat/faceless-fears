extends Resource
class_name Entity

# If false, the item will be rendered in the hand while selected in the hotbar, and the player can right-click to use the item.
# If true, the item will instead render as a ghost in-world while selected, and the player can right-click to place it.
@export var placeable: bool = false

@export var components: Array[Component] = []

func handle_event(event: Event) -> Event:
	for component in components:
		component.handle_event(event)
	return event
	
func fire_event(event_type: String, values: Array) -> Event:
	var event = Event.new()
	event.event_type = event_type
	event.values = values
	return handle_event(event)

func get_physical_entity_scene() -> PackedScene:
	return load("res://scenes/entities/"+self.resource_name+".tscn")
	
func get_ghost_scene() -> PackedScene:
	return load("res://scenes/entities/"+self.resource_name+"_ghost.tscn")
	
func physicalize() -> PhysicalEntity:
	var pe = get_physical_entity_scene().instantiate()
	pe.entity = self
	return pe

func instantiate_ghost() -> Node3D:
	var ghost = get_ghost_scene().instantiate()
	return ghost
