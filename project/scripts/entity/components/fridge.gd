extends Component
class_name Fridge

var upper_door: PhysicsDoor
var lower_door: PhysicsDoor

func handle_event(_entity: Entity, event: Event) -> Event:
	match event.event_type:
		"physicalized":
			upper_door = event.values[0].get_node("StaticBody3D/FridgeModel/UpperDoor")
			lower_door = event.values[0].get_node("StaticBody3D/FridgeModel/LowerDoor")
		"dephysicalized":
			upper_door = null
			lower_door = null
		"geist_pulse":
			upper_door.nudge((randf()-0.2)*event.values[0])
			lower_door.nudge((randf()-0.2)*event.values[0])
	return event
