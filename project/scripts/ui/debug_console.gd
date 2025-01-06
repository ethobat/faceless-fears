extends Control
class_name DebugConsole

@onready var input: Label = $Input
@onready var feedback_label: Label = $Feedback

var valid_keycodes = []

var inp = "":
	set(value):
		inp = value
		input.text = inp + "_"

func _ready():
	visible = false
	input.text = ""
	feedback_label.text = ""
	for i in range(KEY_A, KEY_Z):
		valid_keycodes.push_back(i)
	for i in range(KEY_0, KEY_9):
		valid_keycodes.push_back(i)

func _input(event: InputEvent):
	if visible:
		if event is InputEventKey:
			var ev: InputEventKey = event
			if not ev.pressed: return
			if ev.keycode == KEY_SPACE:
				inp += " "
			if ev.keycode == KEY_BACKSPACE:
				inp = inp.substr(0, inp.length()-1)
			elif ev.keycode == KEY_ENTER:
				do_command(inp)
				inp = ""
			elif ev.keycode in valid_keycodes:
				inp += ev.as_text_key_label().to_lower()

func _process(_delta: float):
	if Input.is_action_just_pressed("debug_console_toggle"):
		visible = not visible
		var player = get_tree().get_first_node_in_group("player")
		player.controls_locked = visible
		player.mouse_look_locked = visible
		return
	if Input.is_action_just_pressed("debug_console_clear"):
		inp = ""

func feedback(msg: String):
	feedback_label.text = msg

func do_command(cmd):
	var split = cmd.split(" ")
	print("running command: " + str(split))
	if split[0] == "noclip":
		var player = get_tree().get_first_node_in_group("player")
		player.toggle_noclip()
		feedback("Noclip: " + str(player.noclip))
	else:
		feedback("Unknown command \"" + cmd + "\".")
