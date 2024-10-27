extends Control

@onready var pause_menu: Control = $PauseMenu
@onready var settings_menu: Control = $SettingsMenu

signal on_menu_opened
signal on_menus_closed

func _ready():
	pause_menu.visible = false

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
