extends Component
class_name Fridge

var upper_door: PhysicsDoor
var lower_door: PhysicsDoor

func handle_event(_entity: Entity, event: Event) -> Event:
	match event.event_type:
		"physicalized":
			upper_door = event.values[0].get_node("StaticBody3D/FridgeModel/UpperDoor")
			lower_door = event.values[0].get_node("StaticBody3D/FridgeModel/LowerDoor")
			upper_door.nudge(2)
			lower_door.nudge(1)
		"upper_door_interact":
			if upper_door.rotation_degrees.y < 50:
				upper_door.nudge(2)
			else:
				upper_door.nudge(-4)
		"lower_door_interact":
			if lower_door.rotation_degrees.y < 50:
				lower_door.nudge(2)
			else:
				lower_door.nudge(-4)
		"dephysicalized":
			upper_door = null
			lower_door = null
	return event
