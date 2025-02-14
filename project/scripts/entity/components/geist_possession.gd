extends Component
class_name GeistPossession

var strength: float = 20.0
var possession_range: float = 5.0

var pulse_interval: float = 5.0
var pulse_interval_variance: float = 4.0
var pulse_timer: float

var jump_interval: float = 15.0
var jump_interval_variance: float = 14.0
var jump_timer: float

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"kill_geist":
			die(entity)
	return event
	
func physical_entity_process(delta: float, pe: PhysicalEntity):
	pulse_timer -= delta
	if pulse_timer <= 0:
		pe.entity.fire_event("geist_pulse", [strength])
		pulse_timer = random_interval(pulse_interval, pulse_interval_variance)
	jump_timer -= delta
	if jump_timer <= 0:
		jump_timer = random_interval(jump_interval, jump_interval_variance)
		possess(pe, get_jump_candidate(pe))

func on_add(entity: Entity):
	entity.fire_event("geist_possession_start", [strength])
	pulse_timer = random_interval(pulse_interval, pulse_interval_variance)
	jump_timer = random_interval(jump_interval, jump_interval_variance)
	
func random_interval(interval: float, variance: float):
	return interval + randf_range(-variance, variance)

func on_remove(entity: Entity):
	entity.fire_event("geist_possession_end", [strength])

func get_jump_candidate(pe: PhysicalEntity):
	var candidates = EntityManager.physical_entities.filter(func(obj): return is_valid_jump_candidate(pe, obj))
	if len(candidates) == 0:
		return []
	return candidates[randi_range(0, len(candidates)-1)]
	
func is_valid_jump_candidate(current: PhysicalEntity, tgt: PhysicalEntity):
	return current != tgt and tgt.entity.fire_event("can_be_possessed", [false, strength]).values[0] and (current.global_position - tgt.global_position).length() <= possession_range
	
func possess(current: PhysicalEntity, target: PhysicalEntity):
	if current != null:
		current.entity.remove_first_component_of_type(GeistPossession)
	target.entity.add_component(self)
	if current != null:
		print("Moved from " + current.name + " to " + target.name)

func die(entity: Entity):
	entity.remove_first_component_of_type(GeistPossession)
