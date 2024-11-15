extends Camera3D

var bobbing: bool = false
var bobbing_fast: bool = false: # Whether the camera should bob faster; no effect if bobbing is false
	set(value):
		# vbdm is tweened so the player gradually breaks into a sprint over 3/10 of a second
		# without this, beginning a sprint makes the camera suddenly jump upwards which looks jarring
		if bobbing_fast and not value: # fast to slow
			if vbdm_tween != null: vbdm_tween.kill()
			vbdm_tween = get_tree().create_tween()
			vbdm_tween.tween_property(self, "vbdm", 1, 0.3)
		if not bobbing_fast and value: # slow to fast
			if vbdm_tween != null: vbdm_tween.kill()
			vbdm_tween = get_tree().create_tween()
			vbdm_tween.tween_property(self, "vbdm", 3, 0.3)
		bobbing_fast = value
var vbdm_tween: Tween = null

@onready var hand: Node3D = $Hand

@export var bob_speed: float = 0.0364
@export var return_speed: float = 0.08
@export var horizontal_bob_distance: float = 0.07
@export var vertical_bob_distance: float = 0.02
@export var hand_horizontal_bob_distance: float = 0.07
@export var hand_vertical_bob_distance: float = 0.02
var vbdm: float = 1

var olp: Vector3 # original local position
var hand_olp: Vector3
var osc: float = 0
var osc_direction: float = 1

func _ready():
	olp = position
	hand_olp = hand.position

func oscillate(delta: float):
	var newval = osc + bob_speed * osc_direction * delta * 60
	if (newval < -1) or (newval > 1):
		osc = osc_direction * (2 - bob_speed) - osc
		osc_direction *= -1
	else:
		osc = newval

func update_position():
	position = olp + basis * Vector3(_ease(osc) * horizontal_bob_distance, abs(_ease(osc)) * vertical_bob_distance*vbdm, 0);
	hand.position = hand_olp + Vector3(_ease(osc) * hand_horizontal_bob_distance, abs(_ease(osc)) * hand_vertical_bob_distance*vbdm, 0);

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
