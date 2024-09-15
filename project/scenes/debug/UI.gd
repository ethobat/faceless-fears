extends Control

@onready var pause_menu: Control = $PauseMenu



func enable_pause_menu():
	pause_menu.visible = true
	
func disable_pause_menu():
	pause_menu.visible = false
