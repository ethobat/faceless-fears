extends Component
class_name GeistPossession

var strength: float = 20

var pulse_interval: float = 1
var pulse_interval_variance: float = 0.5
var pulse_timer: float

func handle_event(entity: Entity, event: Event) -> Event:
	return event
	
func physical_entity_process(delta: float, physical_entity: PhysicalEntity):
	pulse_timer -= delta
	if pulse_timer <= 0:
		physical_entity.entity.fire_event("geist_pulse", [strength])
		pulse_timer = random_interval()

func on_add(entity: Entity):
	entity.fire_event("geist_possession_start", [strength])
	pulse_timer = random_interval()
	
func random_interval():
	return pulse_interval + randf_range(-pulse_interval_variance, pulse_interval_variance)

func on_remove(entity: Entity):
	entity.fire_event("geist_possession_end", [strength])
