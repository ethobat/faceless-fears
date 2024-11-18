extends Node3D
class_name PhysicalEntity

@export var entity: Entity

func _ready():
	entity.fire_event("physicalized", [self])
	self.tree_exited.connect(dephysicalize)

func dephysicalize():
	entity.fire_event("dephysicalized", [self])

func handle_event(event: Event) -> Event:
	return event

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
			
func get_first_child_in_group(group: String):
	for ch in get_all_children():
		if ch.is_in_group(group):
			return ch

func get_first_child_of_type(type):
	for ch in get_all_children():
		if is_instance_of(ch, type):
			return ch

func get_all_children():
	return PhysicalEntity.get_all_children_recursive(self)

static func get_all_children_recursive(node, children := []):
	children.push_back(node)
	for child in node.get_children():
		children = get_all_children_recursive(child, children)
	return children

