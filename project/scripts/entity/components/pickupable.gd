extends Component
class_name Pickupable

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"player_use": # Player, PhysicalEntity
			var player: Player = event.values[0]
			var pe: PhysicalEntity = event.values[1]
			if player.held_item == null and pe != null: # empty hand and in-world
				var try_add = player.entity.fire_event("try_add_item", [entity, 1])
				if try_add.values[1] == 0:
					pe.queue_free()
				else:
					print ("Couldn't pick up item, inventory full")
					pass # TODO error buzz
		"player_look_start":
			event.values[0].add_control_hint("use", "Pick up")
		"player_look_end":
			event.values[0].remove_control_hint("use", "Pick up")
	return event
