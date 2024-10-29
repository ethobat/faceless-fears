extends Control

@onready var sprite: Sprite2D = $Sprite
@onready var label: Label = $Label

var entity: Entity:
	set(value):
		entity = value
		label.text = entity.name
