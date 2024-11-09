extends Component
class_name Inventory

@export var items: Dictionary = {}

func handle_event(event: Event) -> Event:
	match event.event_type:
		"get_item_count": # Entity, int (0)
			for entity in items:
				if entity == event.values[0]:
					event.values[1] += items[entity]
					break
		"get_item_counts": # Dictionary
			for entity in event.values[0]:
				if items.has(entity):
					event.values[0][entity] += items[entity]
		"try_add_item": # Entity, int
			var found_existing_stack = false
			for entity in items:
				if entity == event.values[0]:
					items[entity] += event.values[1]
					event.values[1] = 0
					found_existing_stack = true
					break
			if not found_existing_stack:
				items[event.values[0]] = event.values[1]
		"try_remove_item": # Entity, int, int
			var removed: int = min(items[event.values[0]], event.values[1])
			items[event.values[0]] -= removed
			event.values[1] -= removed
			event.values[2] += removed
		"get_items":
			for entity in items:
				var d: Dictionary = event.values[0]
				if d.has(entity):
					d[entity] += items[entity]
				else:
					d[entity] = items[entity]
	return event
