class_name MoveState
extends BaseState

@export var move_speed: float = 30
@export var rotation_speed: float = 10
@export var lerp_weight: float = 0.1

@export var idle_node: NodePath
@export var dodge_node: NodePath
@export var run_node: NodePath
@export var sneak_node: NodePath
@export var aim_node: NodePath

@onready var idle_state: BaseState = get_node(idle_node)
@onready var dodge_state: BaseState = get_node(dodge_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var sneak_state: BaseState = get_node(sneak_node)
@onready var aim_state: BaseState = get_node(aim_node)

func enter() -> void:
	super.enter()
	
	if character.gun:
		character.gun.use()
		character.busy_hands = true

func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("aim") and character.busy_hands and character.gun:
			return aim_state
	if Input.is_action_just_pressed("space") and not character.busy_hands:
		return dodge_state

	return null

func physics_process(delta: float) -> BaseState:
	var input_dir = get_movement_input()
	
	move(input_dir, delta)
	
	rotate_player(delta)
	
	if abs(character.velocity.x) < 0.01 and abs(character.velocity.y) < 0.01:
		return idle_state

	character.move_and_slide()
	
	return null

func get_movement_input() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

	
func rotate_to_mouse(delta: float):
	# Create horizontal plane
	var player_pos = character.global_transform.origin
	var drop_plane = Plane(Vector3(0, 1, 0), player_pos.y)
	# Project ray from camera
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = character. camera.project_ray_origin(mouse_pos)
	var to = from +  character.camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = drop_plane.intersects_ray(from, to)
	
	if cursor_pos:
		character.look_at(cursor_pos, Vector3.UP)
		#rotation.y = lerp_angle(rotation.y, atan2(cursor_pos.x, cursor_pos.z), ROTATION_SPEED * delta)

func rotate_to_velocity(delta: float):
	character.rotation.y = lerp_angle(
		character.rotation.y,
		atan2(- character.velocity.x, - character.velocity.z),
		rotation_speed * delta
	)

func rotate_player(delta: float):
	if abs(character.velocity.x) > 0 or abs(character.velocity.z) > 0:
		rotate_to_velocity(delta)
	else:
		#rotate_to_mouse(delta)
		pass
	

func move(input_dir: Vector2, delta: float):
	# Add the gravity.
	if not character.is_on_floor():
		character.velocity.y -= character.gravity * delta
	
	var camera_basis = character.spring_arm.global_transform.basis
	var direction = (camera_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		character.velocity.x = lerp(
			character.velocity.x, direction.x * move_speed, lerp_weight
		)
		character.velocity.z = lerp(
			character.velocity.z, direction.z * move_speed, lerp_weight
		)
	else:
		#character.velocity.x = move_toward(character.velocity.x, 0.0, move_speed)
		#character.velocity.z = move_toward(character.velocity.z, 0.0, move_speed)
		character.velocity.x = lerp(character.velocity.x, 0.0, lerp_weight)
		character.velocity.z = lerp(character.velocity.z, 0.0, lerp_weight)

