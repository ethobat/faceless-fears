extends Component
class_name EnergyContainer

# Energy is measured in joules for real life comparisons
@export var energy: float = 0.0
@export var max_energy: float = 24000.0

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"get_energy":
			event.values[0] += energy
		"try_add_energy":
			var added = min(max_energy-energy, event.values[0])
			energy += added
			event.values[0] -= added
		"try_remove_energy":
			var removed = min(energy, event.values[0])
			energy -= removed
			event.values[0] -= removed
			event.values[1] += removed
	return event
