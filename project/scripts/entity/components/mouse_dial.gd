extends Component
class_name MouseDial

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"alt_use_button_pressed":
			print(Input.get_last_mouse_velocity())
			#entity.fire_event("dial", [Input.get_last_mouse_velocity()])
	return event
