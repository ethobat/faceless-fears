extends PhysicalEntity
class_name Player

signal inventory_updated(items: Dictionary)
signal hotbar_items_updated(entities: Array[Entity], counts: Array[int])
signal inventory_button_pressed(items: Dictionary)

@onready var body: CharacterBody3D = $CharacterBody3D
@onready var head: Node3D = $CharacterBody3D/Head
@onready var camera: Camera3D = $CharacterBody3D/Head/Camera3D
@onready var sub_viewport_camera: Camera3D = $CanvasLayer/SubViewportContainer/SubViewport/Camera3D2
@onready var footsteps_player: AudioStreamPlayer3D = $CharacterBody3D/FootstepsPlayer
@onready var hand: Node3D = $CanvasLayer/SubViewportContainer/SubViewport/Hand
@onready var item_ghost_raycast: RayCast3D = $CharacterBody3D/Head/ItemGhostRaycast
@onready var look_raycast: RayCast3D = $CharacterBody3D/Head/LookRaycast

var mouse_motion_relative: Vector2

var look_target: PhysicalEntity

var noclip: bool = false
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
		update_hotbar_items()

func update_hotbar_items():
	var dic = {}
	for en in hotbar_items:
		if en != null:
			dic[en] = 0
	var counts_dict: Dictionary = entity.fire_event("get_item_counts", [dic]).values[0]
	var counts: Array[int] = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
	for i in range(10):
		if counts_dict.has(hotbar_items[i]):
			if counts_dict[hotbar_items[i]] <= 0:
				hotbar_items[i] = null
		if hotbar_items[i] != null:
			counts[i] = counts_dict[hotbar_items[i]]
	hotbar_items_updated.emit(hotbar_items.slice(1), counts.slice(1))

var selected_slot: int = 0: # 0 means no slot is selected
	set(value):
		selected_slot = value
		update_held_item()
	
func toggle_noclip():
	noclip = not noclip
	# todo: disable collision
	var mask = 0 if noclip else 1
	body.collision_layer = mask
	body.collision_mask = mask
	#disable_footsteps()
	
func update_held_item():
	update_hotbar_items()
	held_item = hotbar_items[selected_slot]

var held_item: Entity = null:
	set(value):
		if held_item == value:
			return
		if held_item != null:
			held_item.fire_event("removed_from_hand", [self])
		held_item = value
		if held_item != null:
			held_item.fire_event("placed_in_hand", [self])
		
		# cleanup
		if hand.get_child_count() != 0:
			hand.get_child(0).queue_free()
			
		if held_item == null:
			return
		
		# physicalize item in hand
		if held_item.fire_event("should_render_in_hand", [true]).values[0]:
			var pe = held_item.physicalize()
			pe.disable_collision()
			hand.add_child(pe)

# Awake
func _ready():
	super._ready()
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

func get_items() -> Dictionary:
	return entity.fire_event("get_items", [{}]).values[0]

func toggle_flashlight():
	print("Toggle flashlight")
	# also needs to play sound

func _process(delta: float):
	#tools.rotation = tools.rotation.slerp(camera.rotation, tools_turn_speed);
	
	if look_raycast.is_colliding():
		var parent = look_raycast.get_collider().owner
		if parent is PhysicalEntity:
			if parent != look_target:
				look_target = parent
				look_target.entity.fire_event("player_look_start", [self,look_target])
		else:
			if look_target != null:
				look_target.entity.fire_event("player_look_end", [self,look_target])
			look_target = null
	else:
		look_target = null
	if look_target != null:
		look_target.entity.fire_event("player_look", [self,look_target])
	
	if held_item != null:
		held_item.fire_event("in_hand", [self, mouse_motion_relative])
	
	if Input.is_action_just_pressed("screenshot"):
		print("TODO: Take screenshot")
		#ScreenCapture.CaptureScreenshot("screenshot");
		
	var dv = Vector3.ZERO if noclip else Vector3(0, body.velocity.y - gravity, 0)
		
	if Input.is_action_just_pressed("inventory"):
			inventory_button_pressed.emit(get_items())
		
	if not controls_locked:
		if Input.is_action_just_pressed("use") and look_target != null:
			look_target.entity.fire_event("player_use", [self,look_target])
		
		for n in range(10):
			if Input.is_action_just_pressed("hotbar_"+str(n)):
				if selected_slot == n:
					selected_slot = 0
				else:
					selected_slot = n
				break
		if Input.is_action_just_pressed("flashlight"):
			toggle_flashlight()
		
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
			dv = Quaternion.from_euler(Vector3(head.rotation.x, head.rotation.y, 0)) * Vector3(ad * speed, 0, ws * speed)
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
		sub_viewport_camera.bobbing = false
	else:
		camera.bobbing = true
		sub_viewport_camera.bobbing = true
		
	mouse_motion_relative = Vector2.ZERO

func add_control_hint(_action_name: String, _text: String):
	pass # TODO
	
func remove_control_hint(_action_name: String, _text: String):
	pass # TODO

func _input(event):
	if event is InputEventMouseMotion:
		mouse_motion_relative = event.relative
		if not mouse_look_locked:
			mx += -event.relative.x * sensitivity * get_process_delta_time();
			my = clamp(my + -event.relative.y * sensitivity * get_process_delta_time(), -PI/2, PI/2)
			head.rotation = Vector3(my, mx, 0)
	if event is InputEventKey:
		var ev: InputEventKey = event
		if not ev.pressed: return
		if ev.keycode == KEY_V:
			toggle_noclip()
