extends Node3D
class_name PhysicsDoor

@export_category("Angles")
@export_range(0, 360, 0.01, "radians_as_degrees") var min_angle: float = 0
@export_range(0, 360, 0.01, "radians_as_degrees") var max_angle: float = 90

@export_category("Physics Properties")
@export_range(0, 1) var friction = 0.01
@export_enum("X", "Y", "Z") var axis: int = 1

var angular_velocity: float = 0



@export_category("Interaction Properties")
@export var open_velocity: float = 1
@export var close_velocity: float = 4
@export_range(0,1) var bounce_mult: float = 0.3

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
	if angle < min_angle:
		angular_velocity = 0
	elif angle > max_angle:
		angular_velocity = - angular_velocity * bounce_mult
	angle = clampf(angle, min_angle, max_angle)
	angular_velocity *= (1 - friction)

func nudge(velocity: float):
	angular_velocity += velocity
	
func open_or_close():
	var midpoint = (max_angle-min_angle)/2.0 + min_angle
	print(angle)
	print(midpoint)
	if angle < midpoint:
		open()
	else:
		close()
	
func open():
	nudge(open_velocity)

func close():
	nudge(-close_velocity)
