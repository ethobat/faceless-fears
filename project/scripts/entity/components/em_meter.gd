extends Component
class_name EMMeter


@export var dial_sensitivity: float = 0.001

var dial_value: float = 0.0

var dial: Dial = null

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"physicalized":
			dial = event.values[0].get_first_child_of_type(Dial)
		"in_hand":
			if Input.is_action_just_pressed("alt_use"):
				event.values[0].mouse_look_locked = true
			if Input.is_action_pressed("alt_use"):
				dial_value += event.values[1][0] * dial_sensitivity
				dial_value = clampf(dial_value, 0.0, 1.0)
			dial.set_value(dial_value)
			var tgt: PhysicalEntity = event.values[0].look_target
			if tgt != null:
				var ret = tgt.entity.fire_event("em_probe", [get_dial_value(), 0.0])
			if Input.is_action_just_released("alt_use"):
				event.values[0].mouse_look_locked = false
		"removed_from_hand":
			event.values[0].mouse_look_locked = false
		"dephysicalized":
			dial = null
	return event

func equals(comp: Component):
	return dial_sensitivity == comp.dial_sensitivity and dial_value == comp.dial_value

func get_dial_value():
	return dial
