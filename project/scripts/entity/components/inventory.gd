extends Component
class_name Inventory

@export var items: Dictionary = {}

func handle_event(_entity: Entity, event: Event) -> Event:
	match event.event_type:
		"get_item_count": # Entity, int (0)
			for en in items:
				if en == event.values[0]:
					event.values[1] += items[en]
					break
		"get_item_counts": # Dictionary
			for en in event.values[0]:
				if items.has(en):
					event.values[0][en] += items[en]
		"try_add_item": # Entity, int
			var found_existing_stack = false
			for en in items:
				if en == event.values[0]:
					items[en] += event.values[1]
					event.values[1] = 0
					found_existing_stack = true
					break
			if not found_existing_stack:
				items[event.values[0]] = event.values[1]
		"try_remove_item": # Entity, int, int
			if not items.has(event.values[0]):
				return
			var removed: int = min(items[event.values[0]], event.values[1])
			items[event.values[0]] -= removed
			event.values[1] -= removed
			event.values[2] += removed
			if items[event.values[0]] <= 0:
				items.erase(event.values[0])
		"get_items":
			for en in items:
				var d: Dictionary = event.values[0]
				if d.has(en):
					d[en] += items[en]
				else:
					d[en] = items[en]
	return event
