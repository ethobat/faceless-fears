extends Component
class_name PlayerUIUpdater

var player: Player

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"physicalized":
			player = event.values[0]
		"try_add_item", "try_remove_item":
			player.update_hotbar_items()
	return event
