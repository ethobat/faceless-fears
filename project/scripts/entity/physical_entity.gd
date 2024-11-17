extends Node3D
class_name PhysicalEntity

@export var entity: Entity

func _ready():
	entity.fire_event("physical_entity_ready", [])
	
func disable_collision():
	for ch in get_all_children():
		if ch is CollisionShape3D:
			ch.disabled = true
		if ch is RigidBody3D:
			ch.freeze = true

func freeze():
	for ch in get_all_children():
		if ch is RigidBody3D:
			ch.freeze = true

func get_all_children():
	return get_all_children_recursive(self)

static func get_all_children_recursive(node, children := []):
	children.push_back(node)
	for child in node.get_children():
		children = get_all_children_recursive(child, children)
	return children

