extends Control
class_name EntityPanel

@onready var texture: TextureRect = $TextureRect
@onready var label: Label = $Label

var entity: Entity:
	set(value):
		entity = value
		$Label.text = entity.resource_name

var show_label: bool = true:
	set(value):
		show_label = value
		$Label.visible = show_label
		
