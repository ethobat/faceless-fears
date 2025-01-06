extends Component
class_name EMPattern

@export var pattern_type: int = 0
@export var gradients: Array[Gradient]

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"em_probe":
			if pattern_type == -1 or not entity.fire_event("is_anomalous", [false]).values[0]:
				event.values[1] = 0.0
			else:
				event.values[1] = gradients[pattern_type].sample(event.values[0])[0]
		"suppress_pattern":
			if pattern_type == -1:
				event.values[2] = false
			else:
				if event.values[1] == pattern_type:
					event.values[2] = true
					pattern_type = randi_range(0, len(gradients)-1)
					entity.fire_event("weaken_anomaly", [event.values[0], 0.5])
				else: # Backfire
					entity.fire_event("strengthen_anomaly", [event.values[0], 0.4])
	return event

func equals(_comp: Component):
	return true
