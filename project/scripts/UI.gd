extends Control
class_name UI

signal on_menu_opened
signal on_menus_closed

@onready var pause_menu: Control = $PauseMenu
@onready var settings_menu: Control = $SettingsMenu
@onready var hotbar: EntityPanelGrid = $Hotbar
@onready var player_inventory: InventoryWindow = $PlayerInventory

var paused = false

func _ready():
	pause_menu.visible = false

func _update():
	if Input.is_action_just_pressed("menu"):
		if paused:
			resume()
		else:
			open_pause_menu()

func resume():
	pause_menu.visible = false
	settings_menu.visible = false
	on_menus_closed.emit()
	
func open_pause_menu():
	pause_menu.visible = true
	settings_menu.visible = false
	on_menu_opened.emit()
	
func open_settings_menu():
	pause_menu.visible = false
	settings_menu.visible = true
	on_menu_opened.emit()

func update_hotbar(items: Dictionary):
	hotbar.update(items)
	
func update_player_inventory(items: Dictionary):
	player_inventory.update(items)
