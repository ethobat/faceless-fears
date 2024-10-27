extends CharacterBody3D

@export var ui: NodePath

@onready var camera: Camera3D = $Camera3D
@onready var footsteps_player: AudioStreamPlayer3D = $FootstepsPlayer
var tools: Node3D
var flashlight: Node3D
var anomaly_fixer: Node3D
var fear_bar: ProgressBar
var scan_progress_bar: ProgressBar

var look_target: Node3D
var noclip: bool = false
var max_fear: float = 100
var current_fear: float = 0
var mx: float = 0
var my: float = 0
var raycasted_this_frame: bool = false
var start_pos: Vector3
var played_footsteps_last_frame: bool = false
var paused = false

@export var sprint_forward_multipler: float = 1.2
@export var sprint_sideways_multiplier: float = 1.1
@export var tools_turn_speed: float = 0.9
@export var speed: float = 2
@export var jump_power: float = 2
@export var sensitivity: float = 0.3
@export var gravity: float = 0.07
@export var scroll_sensitivity: float = 1
@export var interaction_distance: float = 2.2
@export var scan_time = 20
@export var enable_debug_hotkeys: bool = false

var controls_locked: bool = false
var mouse_look_locked: bool = false

# Awake
func _ready():
	start_pos = position
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	unlock_controls()
	unlock_mouse_look()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_node(ui).on_menu_opened.connect(on_pause)
	get_node(ui).on_menus_closed.connect(on_unpause)
	
func on_pause():
	lock_controls();
	lock_mouse_look();
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	disable_footsteps();
	paused = true;

func on_unpause():
	unlock_controls();
	unlock_mouse_look();
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	paused = false

func quit_to_desktop():
	get_tree().quit()

#func quit_to_title_screen():
#    # TODO

func enable_footsteps():
	if not played_footsteps_last_frame:
		played_footsteps_last_frame = true
		footsteps_player.play()

func disable_footsteps():
	if played_footsteps_last_frame:
		played_footsteps_last_frame = false
		footsteps_player.stop()

func toggle_flashlight():
	print("Toggle flashlight")
	# also needs to play sound

func _process(delta: float):

	#tools.rotation = tools.rotation.slerp(camera.rotation, tools_turn_speed);

	if Input.is_action_just_pressed("menu"):
		if paused:
			get_node(ui).resume()
		else:
			get_node(ui).open_pause_menu()

	if Input.is_action_just_pressed("screenshot"):
		print("TODO: Take screenshot")
		#ScreenCapture.CaptureScreenshot("screenshot");
		
	var dv = Vector3(0, velocity.y - gravity, 0)
		
	if not get_controls_locked():
		if Input.is_action_just_pressed("flashlight"):
			toggle_flashlight()
		if enable_debug_hotkeys:
			if Input.is_key_pressed(KEY_V):
				noclip = not noclip
				# todo: disable collision
				disable_footsteps();
				print("Noclip "+("enabled" if noclip else "disabled"))
		
		# Movement
		var ad = 1 if Input.is_action_pressed("move_right") else (-1 if Input.is_action_pressed("move_left") else 0)
		var ws = 1 if Input.is_action_pressed("move_backward") else (-1 if Input.is_action_pressed("move_forward") else 0)
		var sprinting = false
		if Input.is_action_pressed("sprint"):
			if ws < 0:
				ws *= sprint_forward_multipler
				sprinting = true
			if ad != 0:
				ad *= sprint_sideways_multiplier
				sprinting = true
		camera.bobbing_fast = sprinting
		footsteps_player.pitch_scale = 1.2 if sprinting else 1
		if noclip:
			dv = camera.rotation * Vector3(ad, 0, ws) * speed
			disable_footsteps()
		else:
			var jump = jump_power if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0
			dv += Quaternion.from_euler(Vector3(0, camera.rotation.y, 0)) * Vector3(ad * speed, jump, ws * speed)
			#dv = Vector3(ad * speed, jump, ws * speed)
			if (ws == 0 and ad == 0) or not is_on_floor():
				disable_footsteps();
			else:
				enable_footsteps();

	# Out of bounds check
	if position.y < -200:
		position = start_pos
		velocity = Vector3.ZERO
		
	velocity = dv * delta * 60
	move_and_slide()
	if velocity == Vector3.ZERO or velocity.y != 0:
		camera.bobbing = false
	else:
		camera.bobbing = true

func _input(event):
	if event is InputEventMouseMotion:
		if not mouse_look_locked:
			mx += -event.relative.x * sensitivity * get_process_delta_time();
			my = clamp(my + -event.relative.y * sensitivity * get_process_delta_time(), -PI/2, PI/2)
			camera.rotation = Vector3(my, mx, 0)

func get_controls_locked() -> bool:
	return controls_locked

func lock_controls():
	controls_locked = true
	disable_footsteps()

func unlock_controls():
	controls_locked = false

func get_mouse_look_locked() -> bool:
	return mouse_look_locked

func lock_mouse_look():
	mouse_look_locked = true

func unlock_mouse_look():
	mouse_look_locked = false

func take_fear_damage(damage: float):
	current_fear += damage
	# update progress bar

func heal_fear(amount: float):
	current_fear -= amount
	# update progress bar
