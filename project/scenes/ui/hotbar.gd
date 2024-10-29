extends HBoxContainer

const ENTITY_UI = preload("res://scenes/ui/entity_ui.tscn")

@export var test_entities: Array[Entity]

func _ready():
	rebuild(test_entities)

func rebuild(entities: Array[Entity]):
	for child in get_children():
		child.queue_free()
	for el in test_entities:
		var slot = ENTITY_UI.new()
		slot.entity = el
