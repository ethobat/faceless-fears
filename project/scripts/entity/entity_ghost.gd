extends Node3D
class_name EntityGhost

@onready var area: Area3D = $Area3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

const material_valid = preload("res://assets/models/materials/ghost_valid.tres")
const material_invalid = preload("res://assets/models/materials/ghost_invalid.tres")

var rotation_offset: float = 0

var in_valid_position: bool = false

func _ready():
	area.body_entered.connect(check_for_collision.unbind(1))
	area.body_exited.connect(check_for_collision.unbind(1))
	check_for_collision()

func _process(_delta: float):
	update_position()

func check_for_collision():
	in_valid_position = not area.has_overlapping_bodies()
	for i in range(mesh.get_surface_override_material_count()):
		mesh.set_surface_override_material(i, material_valid if in_valid_position else material_invalid)

func update_position():
	var player: Node3D = get_tree().get_first_node_in_group("player")
	var igr = player.item_ghost_raycast
	if igr.is_colliding():
		visible = true
		position = igr.get_collision_point()
		position.y += 0.01
	else:
		visible = false
	rotation.y = player.head.rotation.y + rotation_offset
