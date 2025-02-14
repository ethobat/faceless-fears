extends Component
class_name GeistGun

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"in_hand":
			if Input.is_action_just_pressed("use"):
				var tgt: PhysicalEntity = event.values[0].pe_look_target
				if tgt != null:
					generate_geist().possess(null, tgt)
			elif Input.is_action_just_pressed("alt_use"):
				var tgt: PhysicalEntity = event.values[0].pe_look_target
				if tgt != null:
					tgt.entity.fire_event("kill_geist", [false])
					tgt.entity.remove_first_component_of_type(GeistPossession)
					print("Killed geist")
	return event
	
func generate_geist() -> Component:
	var geist = GeistPossession.new()
	return geist
