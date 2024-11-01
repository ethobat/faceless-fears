extends Node3D
class_name PhysicalEntity

@export var entity: Entity

func _ready():
	entity.fire_event("physical_entity_ready", [])
