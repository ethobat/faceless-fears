extends Component
class_name PatternSuppressor

func handle_event(_entity: Entity, event: Event) -> Event:
	return event

func get_dial_value(entity: Entity):
	return entity.fire_event("get_dial", [0.0]).values[0]

