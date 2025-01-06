extends Control
class_name EntityPanel

var show_slot_number = false

func _ready():
	$SlotNumberLabel.visible = show_slot_number

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
		var cl = $CountLabel
		var img = $TextureRect
		var name_label = $Label
		if count < 0:
			cl.visible = false
			img.visible = false
			name_label.visible = false
		else:
			cl.visible = true
			img.visible = true
			name_label.visible = true
			cl.text = str(count)
		
var slot_number: int = 0:
	set(value):
		slot_number = value
		$SlotNumberLabel.text = str(slot_number)
