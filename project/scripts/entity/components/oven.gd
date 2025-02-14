extends Component
class_name Oven

var door: PhysicsDoor

func handle_event(_entity: Entity, event: Event) -> Event:
	match event.event_type:
		"can_be_possessed":
			event.values[0] = true
		"geist_pulse":
			door.nudge((randf()-0.4)*event.values[0])
		"physicalized":
			door = event.values[0].get_node("StaticBody3D/OvenModel/Door")
		"dephysicalized":
			door = null
	return event
