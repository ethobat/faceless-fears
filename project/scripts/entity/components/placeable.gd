extends Component
class_name Placeable

var entity_ghost: EntityGhost = null

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"placed_in_hand":
			entity_ghost = entity.instantiate_ghost()
			entity_ghost.rotation = Vector3.ZERO
			entity_ghost.top_level = true
			event.values[0].add_child(entity_ghost)
			entity_ghost.update_position()
		"in_hand": # Player
			if Input.is_action_just_pressed("use") and entity_ghost.visible:
				var pe = entity.physicalize()
				var player = event.values[0]
				player.entity.fire_event("try_remove_item", [entity, 1, 0])
				pe.position = entity_ghost.position
				pe.rotation = entity_ghost.rotation
				pe.freeze()
				player.get_tree().get_first_node_in_group("placed_entities_parent").add_child(pe)
				event.values[0].update_held_item()
			if Input.is_action_just_pressed("alt_use"):
				event.values[0].mouse_look_locked = true
			if Input.is_action_pressed("alt_use"):
				if entity_ghost != null:
					entity_ghost.rotation_offset += event.values[1][0]/1000.0
			if Input.is_action_just_released("alt_use"):
				event.values[0].mouse_look_locked = false
		"removed_from_hand":
			entity_ghost.queue_free()
			event.values[0].mouse_look_locked = false
	return event
