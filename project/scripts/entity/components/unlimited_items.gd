extends Component
class_name UnlimitedItems

@export var items: Array[Entity]

func handle_event(_entity: Entity, event: Event) -> Event:
	match event.event_type:
		"get_item_count": # Entity, int (0)
			if event.values[0] in items:
				event.values[1] += 999
		"get_item_counts": # Dictionary
			for en in event.values[0]:
				if en in items:
					event.values[0][en] += 999
		"try_add_item": # Entity, int
			if event.values[0] in items:
				event.values[1] = 0
		"try_remove_item": # Entity, int, int
			if event.values[0] in items:
				event.values[2] = event.values[1]
				event.values[1] = 0
		"get_items":
			for en in items:
				if event.values[0].has(en):
					event.values[0][en] += items[en]
				else:
					event.values[0][en] = items[en]
	return event

func equals(_comp: Component):
	return false
