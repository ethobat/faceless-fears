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
			
func _on_player_inventory_button_pressed(player: Entity):
	if not paused:
		if inv_windows_open:
			hide_inv_windows()
		else:
			open_player_inventory(player)

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

func update_hotbar(entities: Array, counts: Array):
	hotbar.update(entities, counts)
	
func open_player_inventory(player: Entity):
	player_inv.visible = true
	other_inv.visible = false
	player_inv.inventory_entity = player
	_on_player_inventory_updated()
	menu_opened.emit()
	
func open_other_inventory(player: Entity, other: Entity):
	player_inv.visible = true
	other_inv.visible = true
	player_inv.inventory_entity = player
	other_inv.inventory_entity = other
	_on_player_inventory_updated()
	on_other_inventory_updated()
	menu_opened.emit()
	
func _on_player_inventory_updated():
	if player_inv.visible:
		player_inv.update()
	
func on_other_inventory_updated():
	other_inv.update()

func hide_inv_windows():
	player_inv.visible = false
	other_inv.visible = false
	menus_closed.emit()

func quit_to_title_screen():
	quit_to_desktop() #TODO

func quit_to_desktop():
	get_tree().quit()
