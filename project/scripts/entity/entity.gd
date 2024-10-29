extends Node3D
class_name Entity

@export var components: Array[Component] = []

func handle_event(event: Event) -> Event:
	for component in components:
		component.handle_event(event)
	return event
	
func fire_event(event_type: String, arguments: Array) -> Event:
	var event = Event.new()
	event.event_type = event_type
	event.arguments = arguments
	return handle_event(event)
