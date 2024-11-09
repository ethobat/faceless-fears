extends Control
class_name UI

signal menu_opened
signal menus_closed

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

func _process(_delta: float):
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
	menus_closed.emit()
	
func open_pause_menu():
	pause_menu.visible = true
	settings_menu.visible = false
	paused = true
	menu_opened.emit()
	
func open_settings_menu():
	pause_menu.visible = false
	settings_menu.visible = true
	paused = true
	menu_opened.emit()

func update_hotbar(items: Dictionary):
	hotbar.update(items)
	print(items)
	
func open_player_inventory(items: Dictionary):
	player_inv.visible = true
	other_inv.visible = false
	_on_player_inventory_updated(items)
	menu_opened.emit()
	
func open_other_inventory(player_items: Dictionary, other_items: Dictionary):
	player_inv.visible = true
	other_inv.visible = true
	_on_player_inventory_updated(player_items)
	on_other_inventory_updated(other_items)
	menu_opened.emit()
	
func _on_player_inventory_updated(items: Dictionary):
	if player_inv.visible:
		player_inv.update(items)
	
func on_other_inventory_updated(items: Dictionary):
	other_inv.update(items)

func hide_inv_windows():
	player_inv.visible = false
	other_inv.visible = false
	menus_closed.emit()
