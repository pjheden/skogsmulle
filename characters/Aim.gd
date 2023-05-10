extends BaseState

@export var dodge_node: NodePath
@export var idle_node: NodePath

@onready var dodge_state: BaseState = get_node(dodge_node)
@onready var idle_state: BaseState = get_node(idle_node)

enum ACTION_SET {PUTUP, AIMING, PUTDOWN, IDLE} 
var current_action = ACTION_SET.PUTUP

func enter() -> void:
	super.enter()
	
	# Freeze movement
	character.velocity.x = 0
	character.velocity.z = 0
	
	current_action = ACTION_SET.PUTUP 
	
	character.animation_tree.animation_finished.connect(_on_Animation_finished)
	
	character.gun.use()

func exit() -> void:
	super.exit()
	
	character.animation_tree.animation_finished.disconnect(_on_Animation_finished)

	
func shoot() -> void:
	if current_action != ACTION_SET.AIMING:
		return
		
	if not character.gun.shoot():
		return
	
	character.animation_state_machine.travel("StandFire")

func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("action"):
		shoot()
	
	if Input.is_action_just_pressed("aim"):
		toggle_aiming()
	
	return null

func process(delta: float) -> BaseState:
	if current_action == ACTION_SET.IDLE:
		return idle_state
	
	return null
	
func physics_process(delta: float) -> BaseState:
	character.velocity.y -= character.gravity * delta
	character.move_and_slide()
	
	rotate_to_mouse(delta)
	
	return null

func rotate_to_mouse(delta: float) -> void:
	# Create horizontal plane
	var player_pos = character.global_transform.origin
	var drop_plane = Plane(Vector3(0, 1, 0), player_pos.y)
	# Project ray from camera
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = character.camera.project_ray_origin(mouse_pos)
	var to = from +  character.camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = drop_plane.intersects_ray(from, to)
	
	if cursor_pos:
		character.look_at(cursor_pos, Vector3.UP)


func toggle_aiming() -> void:
	if current_action == ACTION_SET.PUTDOWN:
		resume_aiming()
	else:
		exit_aiming()
	

func exit_aiming() -> void:
	character.animation_state_machine.travel("IdleRunRifleBlend")
	current_action = ACTION_SET.PUTDOWN
	
func resume_aiming() -> void:
	if current_action != ACTION_SET.PUTDOWN:
		return
	
	character.animation_state_machine.travel(animation_name)
	current_action = ACTION_SET.PUTUP


func update_animation(anim: StringName, finished: bool) -> void:
	if current_action == ACTION_SET.PUTUP and finished:
		current_action = ACTION_SET.AIMING
	elif current_action == ACTION_SET.PUTDOWN and finished and anim == "StandAim":
		current_action = ACTION_SET.IDLE

func _on_Animation_started(anim_name: StringName) -> void:
	update_animation(anim_name, false)

func _on_Animation_finished(anim_name: StringName) -> void:
	update_animation(anim_name, true)
