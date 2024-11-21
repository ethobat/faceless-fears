extends Component
class_name StaticPrismAnomaly

@export var inactive_material: Material

var body: RigidBody3D
var mesh: MeshInstance3D
var audio: AudioStreamPlayer3D

func handle_event(_entity: Entity, event: Event) -> Event:
	match event.event_type:
		"physicalized":
			body = event.values[0].get_node("RigidBody3D")
			body.freeze = true
			mesh = body.get_node("MeshInstance3D")
			audio = body.get_node("Hum")
		"strengthen_anomaly":
			var t: Tween = event.values[0].get_tree().create_tween()
			t.tween_property(audio, "pitch_scale", audio.pitch_scale+event.values[1], 2.0)
		"weaken_anomaly":
			var t: Tween = event.values[0].get_tree().create_tween()
			if audio.pitch_scale - event.values[1] <= 0:
				t.tween_property(audio, "pitch_scale", 0.001, 2.0)
				t.tween_callback(neutralize)
			else:
				t.tween_property(audio, "pitch_scale", audio.pitch_scale-event.values[1], 2.0)
		"dephysicalized":
			body = null
			mesh = null
			audio = null
	return event

func neutralize():
	print("Neutralized!")
	mesh.set_surface_override_material(0, inactive_material)
	audio.playing = false
	body.freeze = false
	body.linear_velocity = Vector3.ZERO
	body.rotation_active = false
