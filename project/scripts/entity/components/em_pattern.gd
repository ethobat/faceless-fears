extends Component
class_name EMPattern

@export var gradient: Gradient

func handle_event(_entity: Entity, event: Event) -> Event:
	match event.event_type:
		"em_probe":
			event.values[1] = gradient.sample(event.values[0])[0]
	return event

func equals(_comp: Component):
	return true
