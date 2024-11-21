extends Component
class_name EMMeter

var display: MultiDigitDisplay

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"physicalized":
			display = event.values[0].get_node("RigidBody3D/SubViewport/EMMeterDisplay")
		"in_hand":
			var tgt: PhysicalEntity = event.values[0].look_target
			if tgt != null:
				var ret = tgt.entity.fire_event("em_probe", [get_dial_value(entity), 0.0])
				var time = Time.get_ticks_msec() / 500.0 
				display.num = ret.values[1] * 120 + (sin(time) + sin(time/2) + sin(time/3))/3.0
			else:
				display.num = 0
		"dephysicalized":
			display = null
	return event

func get_dial_value(entity: Entity):
	return entity.fire_event("get_dial", [0.0]).values[0]
