extends Component
class_name MouseDial

@export var dial_sensitivity: float = 0.001

var dial_value: float = 0.0

var dial: Dial = null

func handle_event(_entity: Entity, event: Event) -> Event:
	match event.event_type:
		
		# Respond to the "get_dial" event and return the dial value.
		"get_dial":
			event.values[0] = dial_value
			
		# When an entity with this component is physicalized, get any child of the PhysicalEntity scene with the Dial script attached to it. This object will be rotated to reflect this entity's dial_value. Look at em_meter_model.tscn for an example of a physical dial.
		"physicalized": 
			dial = event.values[0].get_first_child_of_type(Dial)
			
		# Every frame while held:
		"in_hand":
			
			 # If the player just started right-clicking, prevent them from looking around by moving the mouse.
			if Input.is_action_just_pressed("alt_use"):
				event.values[0].mouse_look_locked = true
				
			# While the player is holding the right mouse button, get the horizontal mouse motion and use it to turn the dial.
			if Input.is_action_pressed("alt_use"):
				dial_value += event.values[1][0] * dial_sensitivity
				dial_value = clampf(dial_value, 0.0, 1.0) # Clamp the dial value, so it can't be less than 0 or greater than 1.
			dial.set_value(dial_value) # The actual turning of the physical dial is handled by its dial script.
			
			# Allow the player to look around again once the right mouse button is released.
			if Input.is_action_just_released("alt_use"):
				event.values[0].mouse_look_locked = false
				
		# Release the mouse look lock once the entity is removed from the player's hand, because they might switch to another item without releasing the right mouse button, and this would cause them to become stuck.
		"removed_from_hand":
			event.values[0].mouse_look_locked = false
			
		# When the PhysicalEntity disappears, set the physical dial reference to null. This isn't strictly necessary, it's just for safety, because having a non-physicalized entity with a reference to a node could cause some weird errors.
		"dephysicalized":
			dial = null
			
	return event

# This overrides component's equals function and is used to test equality between components. This MouseDial component is equivalent to another MouseDial component if and only if the dial position and the sensitivity are both the same.
func equals(comp: Component):
	return dial_sensitivity == comp.dial_sensitivity and dial_value == comp.dial_value
