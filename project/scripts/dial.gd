extends Node3D
class_name Dial

@export var min_y: float = -120.0
@export var max_y: float = 120.0
@export var reverse: bool = false

func set_value(value: float): # value is in range 0~1
	if reverse:
		value = 1.0 - value
	rotation.y = deg_to_rad(lerp(min_y, max_y, value))
