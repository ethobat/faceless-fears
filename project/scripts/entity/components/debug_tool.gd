extends Component
class_name DebugTool

@export var test_name: String

func handle_event(entity: Entity, event: Event) -> Event:
	print(test_name + " " + event.event_type)
	return event

func equals(comp: Component):
	pass
