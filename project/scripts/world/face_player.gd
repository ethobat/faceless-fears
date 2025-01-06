extends Node3D

var rotation_active = true
@export var rotate_speed = 0.1
@onready var tgt: Vector3 = position

func _ready():
	tgt = get_tree().get_first_node_in_group("player").camera.global_position

func _process(_delta: float):
	if rotation_active:
		tgt = lerp(tgt, get_tree().get_first_node_in_group("player").camera.global_position, rotate_speed)
		look_at(tgt)
