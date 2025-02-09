extends Component
class_name EMMeter

var display: MultiDigitDisplay

# This component appears on the EMMeter entity. It reads the entity's dial value (which in this case is provided by a MouseDial component) and uses it to check the EM radiation of whatever entity the player's looking at.

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"physicalized":
			display = event.values[0].get_node("RigidBody3D/EMMeterModel/SubViewport/EMMeterDisplay")
		"in_hand": # "in_hand" - this code gets run every frame while the player is holding this entity.
			# "noise" is a pseudo-random value that is added to the displayed noise. This is meant to simulate fluctuations in the reading that you would see in real life. Without the noise, the meter would always display a fixed value.
			var time = Time.get_ticks_msec() / 500.0 
			var noise = ((sin(time) + sin(time/2) + sin(time/3))/3.0) + 0.01
			# Get the PhysicalEntity the player is currently looking at.
			var tgt: PhysicalEntity = event.values[0].pe_look_target
			# If the player is actually looking at a physical entity:
			if tgt != null:
				# Send the em_probe event to the target entity, using this entity's value as the first argument. If the target entity doesn't respond to the event, the return value will be 0.
				var ret = tgt.entity.fire_event("em_probe", [get_dial_value(entity), 0.0])
				# Get the return value of this effect, multiplied by 120, and add the random noise.
				display.num = ret.values[1] * 120 + noise
			else:
				# If the player isn't looking at an entity, just output the noise to simulate background radiation.
				display.num = noise
		"dephysicalized": # When the PhysicalEntity disappears, set display to null. This isn't strictly necessary, it's just for safety, because having a non-physicalized entity with a reference to a node could cause some weird errors.
			display = null
	return event

func get_dial_value(entity: Entity): # Get the dial value of this entity. In the EM meter's case, the dial value is provided by a MouseDial component.
	return entity.fire_event("get_dial", [0.0]).values[0]
