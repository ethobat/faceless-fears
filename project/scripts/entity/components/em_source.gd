extends Component
class_name EMSource

func handle_event(_entity: Entity, event: Event) -> Event:
	match event.event_type:
		"em_probe":
			event.values[1] = 0.6
	return event

func equals(_comp: Component):
	return true
