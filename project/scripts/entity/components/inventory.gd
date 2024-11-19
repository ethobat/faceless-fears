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
				var key = Inventory.dic_has(items, en)
				if key != null:
					event.values[0][en] += items[key]
		"try_add_item": # Entity, int
			var found_existing_stack = false
			for en in items:
				if en.equals(event.values[0]):
					items[en] += event.values[1]
					event.values[1] = 0
					found_existing_stack = true
					break
			if not found_existing_stack:
				items[event.values[0]] = event.values[1]
				event.values[1] = 0
		"try_remove_item": # Entity, int, int
			var key = Inventory.dic_has(items, event.values[0])
			if key != null:
				var removed: int = min(items[key], event.values[1])
				items[key] -= removed
				event.values[1] -= removed
				event.values[2] += removed
				if items[key] <= 0:
					items.erase(key)
		"get_items":
			for en in items:
				var key = Inventory.dic_has(event.values[0], en)
				if key != null:
					event.values[0][key] += items[en]
				else:
					event.values[0][en] = items[en]
	return event
	
static func dic_has(dic: Dictionary, key: Entity):
	for en in dic:
		if en.equals(key):
			return en
	return null
	
func equals(comp: Component): # Two entities with Inventory can only stack if they are both empty
	return items == {} and comp.items == {}
