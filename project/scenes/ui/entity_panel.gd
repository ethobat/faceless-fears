extends Control
class_name EntityPanel

@onready var texture: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var count_label: Label = $CountLabel

var entity: Entity:
	set(value):
		entity = value
		if entity == null:
			$Label.text = "NULL"
		else:
			$Label.text = entity.resource_name

var show_label: bool = true:
	set(value):
		show_label = value
		$Label.visible = show_label
		
var count: int = 0:
	set(value):
		count = value
		$CountLabel.text = str(count)
