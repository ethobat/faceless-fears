extends Node3D
class_name PhysicsDoor

@export_range(0, 360, 0.01, "radians_as_degrees") var min_angle: float = 0
@export_range(0, 360, 0.01, "radians_as_degrees") var max_angle: float = 90
@export_range(0, 1) var friction = 0.1

var angular_velocity: float = 0

func _physics_process(delta):
	rotation.y = rotation.y + angular_velocity * delta
	if rotation.y < min_angle:
		angular_velocity = 0
	elif rotation.y > max_angle:
		angular_velocity = -angular_velocity/2
	rotation.y = clampf(rotation.y, min_angle, max_angle)
	angular_velocity *= (1 - friction)

func nudge(velocity: float):
	angular_velocity += velocity
	
