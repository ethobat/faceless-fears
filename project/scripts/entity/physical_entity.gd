extends Node3D
class_name PhysicalEntity

@export var entity: Entity

func _ready():
	entity.fire_event("physical_entity_ready", [])
	
func disable_physics():
	disable_physics_on_node(self)

static func disable_physics_on_node(node):
	if node is CollisionShape3D:
		node.disabled = true
	if node is RigidBody3D:
		node.freeze = true
	for ch in node.get_children():
		disable_physics_on_node(ch)
