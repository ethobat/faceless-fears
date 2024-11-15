extends PhysicalEntity
class_name Player

signal inventory_updated(items: Dictionary)
signal hotbar_items_updated(items: Dictionary)
signal inventory_button_pressed(items: Dictionary)

@onready var body: CharacterBody3D = $CharacterBody3D
@onready var head: Node3D = $CharacterBody3D/Head
@onready var camera: Camera3D = $CharacterBody3D/Head/Camera3D
@onready var footsteps_player: AudioStreamPlayer3D = $CharacterBody3D/FootstepsPlayer
@onready var hand: Node3D = $CharacterBody3D/Head/Camera3D/Hand
@onready var item_ghost_raycast: RayCast3D = $CharacterBody3D/Head/ItemGhostRaycast

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

@export var sprint_forward_multipler: float = 1.8
@export var sprint_sideways_multiplier: float = 1.5
@export var tools_turn_speed: float = 0.9
@export var speed: float = 1
@export var jump_power: float = 2
@export var sensitivity: float = 0.3
@export var gravity: float = 0.07
@export var scroll_sensitivity: float = 1
@export var interaction_distance: float = 2.2
@export var scan_time = 20
@export var enable_debug_hotkeys: bool = false

var controls_locked: bool = false:
	set(value):
		controls_locked = value
		if value:
			disable_footsteps()
var mouse_look_locked: bool = false

var hotbar_items: Array[Entity]: # 0th element is always null
	set(value):
		hotbar_items = value
		var dic = {}
		for en in hotbar_items:
			if en != null:
				dic[en] = 0
			hotbar_items_updated.emit(entity.fire_event("get_item_counts", [dic]).values[0])

var selected_slot: int = 0: # 0 means no slot is selected
	set(value):
		selected_slot = value
		held_item = hotbar_items[selected_slot]

var held_item: Entity = null:
	set(value):
		held_item = value
		
		# cleanup
		if hand.get_child_count() != 0:
			hand.get_child(0).queue_free()
		held_item_ghost = null
		item_ghost_raycast.enabled = false
		if held_item == null:
			return
		
		# instantiating item
		if held_item.placeable:
			item_ghost_raycast.enabled = true
			held_item_ghost = held_item.instantiate_ghost()
			held_item_ghost.top_level = true # might not be necessary, try removing
			hand.add_child(held_item_ghost)
			held_item_ghost.rotation = Vector3.ZERO
			update_held_item_ghost()
		else:
			var pe = held_item.physicalize()
			pe.disable_physics()
			hand.add_child(pe)
			
var held_item_ghost: Node3D = null

# Awake
func _ready():
	start_pos = body.position
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	controls_locked = false
	mouse_look_locked = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	var hi: Array[Entity] = [null, null, null, null, null, null, null, null, null, null]
	var n = 1
	for en in get_items():
		hi[n] = en
		n += 1
		if n == 9:
			break
	hotbar_items = hi
	
func _on_ui_menu_opened():
	controls_locked = true
	mouse_look_locked = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	disable_footsteps()

func _on_ui_menus_closed():
	controls_locked = false
	mouse_look_locked = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

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
		
func get_hotbar_items() -> Dictionary:
	return get_items() # TODO

func get_items() -> Dictionary:
	return entity.fire_event("get_items", [{}]).values[0]

func toggle_flashlight():
	print("Toggle flashlight")
	# also needs to play sound

func update_held_item_ghost():
	if item_ghost_raycast.is_colliding():
		held_item_ghost.visible = true
		held_item_ghost.position = item_ghost_raycast.get_collision_point()
	else:
		held_item_ghost.visible = false

func _process(delta: float):

	#tools.rotation = tools.rotation.slerp(camera.rotation, tools_turn_speed);
	
	if Input.is_action_just_pressed("screenshot"):
		print("TODO: Take screenshot")
		#ScreenCapture.CaptureScreenshot("screenshot");
		
	var dv = Vector3(0, body.velocity.y - gravity, 0)
		
	if Input.is_action_just_pressed("inventory"):
			inventory_button_pressed.emit(get_items())
		
	if not controls_locked:
		if held_item_ghost != null:
			update_held_item_ghost()
		for n in range(10):
			if Input.is_action_just_pressed("hotbar_"+str(n)):
				if selected_slot == n:
					selected_slot = 0
				else:
					selected_slot = n
				break
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
		footsteps_player.pitch_scale = 1.2 if sprinting else 1.0
		if noclip:
			dv = head.rotation * Vector3(ad, 0, ws) * speed
			disable_footsteps()
		else:
			var jump = jump_power if Input.is_action_just_pressed("jump") and body.is_on_floor() else 0.0
			dv += Quaternion.from_euler(Vector3(0, head.rotation.y, 0)) * Vector3(ad * speed, jump, ws * speed)
			#dv = Vector3(ad * speed, jump, ws * speed)
			if (ws == 0 and ad == 0) or not body.is_on_floor():
				disable_footsteps();
			else:
				enable_footsteps();

	# Out of bounds check
	if body.position.y < -200:
		body.position = start_pos
		body.velocity = Vector3.ZERO
		
	body.velocity = dv * delta * 60
	body.move_and_slide()
	if body.velocity == Vector3.ZERO or body.velocity.y != 0:
		camera.bobbing = false
	else:
		camera.bobbing = true

func _input(event):
	if event is InputEventMouseMotion:
		if not mouse_look_locked:
			mx += -event.relative.x * sensitivity * get_process_delta_time();
			my = clamp(my + -event.relative.y * sensitivity * get_process_delta_time(), -PI/2, PI/2)
			head.rotation = Vector3(my, mx, 0)

func take_fear_damage(damage: float):
	current_fear += damage
	# update progress bar

func heal_fear(amount: float):
	current_fear -= amount
	# update progress bar
