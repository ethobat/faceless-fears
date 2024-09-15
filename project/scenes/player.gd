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
var scanning: bool = false
var scan_progress: float = 0
var played_footsteps_last_frame: bool = false

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
	hide_pause_menu();
	
func show_pause_menu():
	#PauseMenu.SetActive(true);
	#SettingsMenu.SetActive(false);
	lock_controls();
	lock_mouse_look();
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	stop_scanning();
	on_stop_moving();

func hide_pause_menu():
	#PauseMenu.SetActive(false);
	#SettingsMenu.SetActive(false);
	unlock_controls();
	unlock_mouse_look();
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# For now, assume this can be called when the pause menu is not active
func show_settings_menu():
	#PauseMenu.SetActive(false);
	#SettingsMenu.SetActive(true);
	lock_controls();
	lock_mouse_look();
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func quit_to_desktop():
	get_tree().quit()

#func quit_to_title_screen():
#    # TODO

func start_scanning():
	scanning = true
	scan_progress = 0
	#scan_progress_bar.gameObject.SetActive(true);
	#AudioSource source = AnomalyFixer.GetComponent<AudioSource>();
	#source.loop = true;
	#source.clip = AnomalyFixerScanLoop;
	#source.Play();

func stop_scanning():
	scanning = false
	scan_progress = 0
	#scan_progress_bar.gameObject.SetActive(false);
	#anomaly_fixer.GetComponent<AudioSource>().Stop()

func while_moving():
	if not played_footsteps_last_frame:
		played_footsteps_last_frame = true
		footsteps_player.play()

func on_stop_moving():
	if played_footsteps_last_frame:
		played_footsteps_last_frame = false
		footsteps_player.stop()

func toggle_flashlight():
	print("Toggle flashlight")
	# also needs to play sound

func _process(delta: float):

	#tools.rotation = tools.rotation.slerp(camera.rotation, tools_turn_speed);

	if Input.is_action_just_pressed("menu"):
		toggle_pause_menu()

	if Input.is_action_just_pressed("screenshot"):
		print("TODO: Take screenshot")
		#ScreenCapture.CaptureScreenshot("screenshot");
		
	var dv = Vector3(0, velocity.y - gravity, 0)
		
	if not get_controls_locked():
		if Input.is_action_just_pressed("interact"):
			start_scanning()
		if Input.is_action_just_released("interact"):
			stop_scanning()
		if Input.is_action_just_pressed("flashlight"):
			toggle_flashlight()
		if enable_debug_hotkeys:
			if Input.is_key_pressed(KEY_V):
				noclip = not noclip
				# todo: disable collision
				on_stop_moving();
				print("Noclip "+("enabled" if noclip else "disabled"))
		
		# Movement
		var ad = 1 if Input.is_action_pressed("move_right") else (-1 if Input.is_action_pressed("move_left") else 0)
		var ws = 1 if Input.is_action_pressed("move_backward") else (-1 if Input.is_action_pressed("move_forward") else 0)
		if noclip:
			dv = camera.rotation * Vector3(ad, 0, ws) * speed
		else:
			var jump = jump_power if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0
			dv += Quaternion.from_euler(Vector3(0, camera.rotation.y, 0)) * Vector3(ad * speed, jump, ws * speed)
			#dv = Vector3(ad * speed, jump, ws * speed)
			if ws == 0 and ad == 0:
				on_stop_moving();
			else:
				while_moving();

	# Out of bounds check
	if position.y < -200:
		position = start_pos
		velocity = Vector3.ZERO
		
	velocity = dv
	move_and_slide()
	if velocity == Vector3.ZERO or velocity.y != 0:
		camera.bobbing = false
	else:
		camera.bobbing = true

func _input(event):
	if event is InputEventMouseMotion:
		mx += -event.relative.x * sensitivity * get_process_delta_time();
		my = clamp(my + -event.relative.y * sensitivity * get_process_delta_time(), -PI/2, PI/2)
		if not mouse_look_locked:
			camera.rotation = Vector3(my, mx, 0)

func get_controls_locked() -> bool:
	return controls_locked

func lock_controls():
	controls_locked = true
	stop_scanning()
	on_stop_moving()

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
