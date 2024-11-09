extends Resource
class_name Entity

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
	
func physicalize() -> PhysicalEntity:
	var pe = get_physical_entity_scene().instantiate()
	pe.entity = self
	return pe
