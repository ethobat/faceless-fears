extends Component
class_name PatternSuppressor

var target_pattern = 0
var last_pattern = 2

var display: SevenSegmentDisplay

func handle_event(_entity: Entity, event: Event) -> Event:
	match event.event_type:
		"physicalized":
			display = event.values[0].get_node("SubViewport/PatternSuppressorDisplay")
		"in_hand":
			if Input.is_action_just_pressed("use"):
				var tgt: PhysicalEntity = event.values[0].look_target
				if tgt != null:
					var ret = tgt.entity.fire_event("suppress_pattern", [tgt, target_pattern, false])
					if ret.values[2]: # Success
						print("Success!")
					else: # Failure
						print("Failed...")
			if Input.is_action_just_pressed("alt_use"):
				if target_pattern == last_pattern:
					target_pattern = 0
				else:
					target_pattern += 1
			display.chr = str(target_pattern)
		"dephysicalized":
			display = null
	return event

func get_dial_value(entity: Entity):
	return entity.fire_event("get_dial", [0.0]).values[0]
