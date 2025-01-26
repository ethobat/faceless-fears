extends Component
class_name Flashlight

var light: SpotLight3D
var initial_energy: float
var on_sound: AudioStreamPlayer3D
var off_sound: AudioStreamPlayer3D

var physical_entity: PhysicalEntity

var close_pos: Vector3 = Vector3(-0.32, -0.1, 0.35)

var tgt_pos: Vector3

func handle_event(entity: Entity, event: Event) -> Event:
	match event.event_type:
		"physicalized":
			light = event.values[0].get_node("RigidBody3D/SpotLight3D")
			on_sound = event.values[0].get_node("RigidBody3D/OnSound")
			off_sound = event.values[0].get_node("RigidBody3D/OffSound")
			initial_energy = light.light_energy
			physical_entity = event.values[0]
		"in_hand":
			if Input.is_action_just_pressed("alt_use"):
				if light.visible:
					light.visible = false
					off_sound.play()
				else:
					light.visible = true
					on_sound.play()
			var time = Time.get_ticks_msec() / 300.0
			var noise = ((sin(2*time)+sin(PI*time))/2 + 1)/10
			light.light_energy = initial_energy + noise
			var player: Player = event.values[0]
			tgt_pos = entity.hand_position
			if player.long_raycast.is_colliding():
				var target_point = player.long_raycast.get_collision_point()
				if (player.camera.global_position - target_point).length() < 0.7:
					tgt_pos = close_pos
				physical_entity.look_at(target_point)
				physical_entity.rotate_object_local(Vector3.UP, -PI/2)
			else:
				point_normally(physical_entity)
			physical_entity.position = lerp(physical_entity.position, tgt_pos, 0.1)
		"dephysicalized":
			light = null
			on_sound = null
			off_sound = null
			physical_entity = null
	return event

func point_normally(pe: PhysicalEntity):
	pe.rotation_degrees = Vector3(0,-90,0)
