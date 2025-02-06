extends Node3D
class_name Spinner

@export_range(0, 1) var friction = 0.01
@export_enum("X", "Y", "Z") var axis: int = 1
@export var motor_power: float = 0
@export var motor_on: bool = false

var angular_velocity: float = 0

var angle:
	get:
		match(axis):
			0: return rotation.x
			1: return rotation.y
			2: return rotation.z
	set(value):
		match(axis):
			0: rotation.x = value
			1: rotation.y = value
			2: rotation.z = value
			
var angle_degrees:
	get:
		match(axis):
			0: return rotation_degrees.x
			1: return rotation_degrees.y
			2: return rotation_degrees.z
	set(value):
		match(axis):
			0: rotation_degrees.x = value
			1: rotation_degrees.y = value
			2: rotation_degrees.z = value
			
func _physics_process(delta):
	angle = angle + angular_velocity * delta
	if motor_on:
		angular_velocity += motor_power
	angular_velocity *= (1 - friction)
	
func toggle_motor():
	motor_on = not motor_on
