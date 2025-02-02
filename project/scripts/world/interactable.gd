extends Node3D
class_name Interactable

signal start_looking(player)
signal looking(player)
signal stop_looking(player)
signal interact_start(player)
signal interact(player)
signal interact_end(player)

@export var show_hint: bool = false
@export_multiline var hint: String = ""

@export var physical_entity: PhysicalEntity = null
@export var event_type: String = ""

func _ready():
	start_looking.connect(_show_hint)
	stop_looking.connect(_hide_hint)
	interact.connect(_on_interact)
	
func _on_interact(player):
	if physical_entity != null:
		physical_entity.fire_event(event_type)
	
func _show_hint(player: Player):
	if show_hint:
		player.interaction_hint = hint
	
func _hide_hint(player: Player):
	if show_hint:
		player.interaction_hint = ""
