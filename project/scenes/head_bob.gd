extends Camera3D

var bobbing: bool = false

@export var return_speed: float = 0.08
@export var bob_speed: float = 0.0364
@export var horizontal_bob_distance: float = 0.07
@export var vertical_bob_distance: float = 0.02

var original_local_position: Vector3
var osc: float = 0
var osc_direction: float = 1

func _ready():
	original_local_position = position

func oscillate(delta: float):
	var newval = osc + bob_speed * osc_direction * delta * 60
	if (newval < -1) or (newval > 1):
		osc = osc_direction * (2 - bob_speed) - osc
		osc_direction *= -1
	else:
		osc = newval

func update_position():
	position = original_local_position + basis * Vector3(_ease(osc) * horizontal_bob_distance, abs(_ease(osc)) * vertical_bob_distance, 0);

func _ease(x: float) -> float:
	if x >= 0:
		return x * (2 - x)
	else:
		return x * (2 + x)

func _physics_process(delta):
	if bobbing:
		oscillate(delta)
	else:
		osc *= 1 - return_speed
	update_position();
