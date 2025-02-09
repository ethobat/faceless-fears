extends Resource
class_name Component

func handle_event(_entity: Entity, event: Event) -> Event:
	return event

func equals(_comp: Component):
	return true

# Run when this component is added to an existing entity
func on_add(entity: Entity):
	pass
	
# Run just before this component is removed from an entity
func on_remove(entity: Entity):
	pass

func physical_entity_process(delta: float, physical_entity: PhysicalEntity):
	pass
