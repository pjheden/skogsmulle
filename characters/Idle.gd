extends BaseState

@export var sneak_node: NodePath
@export var run_node: NodePath
@export var dodge_node: NodePath
@export var aim_node: NodePath

@onready var sneak_state: BaseState = get_node(sneak_node)
@onready var run_state: BaseState = get_node(run_node)
@onready var dodge_state: BaseState = get_node(dodge_node)
@onready var aim_state: BaseState = get_node(aim_node)

func enter() -> void:
	super.enter()
	
	character.velocity.x = 0
	character.velocity.z = 0
	
	if character.gun:
		character.gun.use()
		character.busy_hands = true

func input(event: InputEvent) -> BaseState:
	var ev = super.input(event)
	if ev:
		return ev
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		if Input.is_action_pressed("sneak") and not character.busy_hands:
			return sneak_state
		return run_state
	elif Input.is_action_just_pressed("space"):
		return dodge_state
	elif Input.is_action_just_pressed("aim"):
		if character.busy_hands and aim_state and character.gun:
			return aim_state
	return null

func physics_process(delta: float) -> BaseState:
	character.velocity.y -= character.gravity * delta
	character.move_and_slide()
	
	return null
