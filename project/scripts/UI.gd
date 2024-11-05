extends Control
class_name UI

signal on_menu_opened
signal on_menus_closed

@onready var pause_menu: Control = $PauseMenu
@onready var settings_menu: Control = $SettingsMenu
@onready var hotbar: EntityPanelGrid = $Hotbar
@onready var player_inv: InventoryWindow = $MarginContainer/InventoryWindowsContainer/PlayerInventory
@onready var other_inv: InventoryWindow = $MarginContainer/InventoryWindowsContainer/OtherInventory

var paused = false

var inv_windows_open:
	get:
		return player_inv.visible or other_inv.visible

func _ready():
	pause_menu.visible = false
	hide_inv_windows()

func _process(delta: float):
	if Input.is_action_just_pressed("menu"):
		if paused:
			resume()
		else:
			open_pause_menu()
			
func _on_player_inventory_button_pressed(items: Dictionary):
	if not paused:
		if inv_windows_open:
			hide_inv_windows()
		else:
			open_player_inventory(items)

func resume():
	pause_menu.visible = false
	settings_menu.visible = false
	paused = false
	on_menus_closed.emit()
	
func open_pause_menu():
	pause_menu.visible = true
	settings_menu.visible = false
	paused = true
	on_menu_opened.emit()
	
func open_settings_menu():
	pause_menu.visible = false
	settings_menu.visible = true
	paused = true
	on_menu_opened.emit()

func update_hotbar(items: Dictionary):
	hotbar.update(items)
	
func open_player_inventory(items: Dictionary):
	player_inv.visible = true
	other_inv.visible = false
	update_player_inventory(items)
	
func open_other_inventory(player_items: Dictionary, other_items: Dictionary):
	player_inv.visible = true
	other_inv.visible = true
	update_player_inventory(player_items)
	update_other_inventory(other_items)
	
func update_player_inventory(items: Dictionary):
	if player_inv.visible:
		player_inv.update(items)
	
func update_other_inventory(items: Dictionary):
	other_inv.update(items)

func hide_inv_windows():
	player_inv.visible = false
	other_inv.visible = false
