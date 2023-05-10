class_name DodgeState
extends MoveState

@export var dodge_time: float = 0.4

var current_dodge_time: float = 0
var dodge_direction: Vector2 = Vector2.ZERO

# Upon entering the state, set dodge direction to either current input or the direction the player is facing if no input is pressed
func enter() -> void:
	super.enter()
	
#	if character.gun:
#		character.gun.equip(character)
	
	current_dodge_time = dodge_time
	
	# alter dodge animation to fit within dodge time
	var speed_factor: float = character.animations.get_animation(animation_name).length / dodge_time
	character.animation_tree.set("parameters/Dive/TimeScale/scale", speed_factor)
	
	# Set dodge direction to current input
	dodge_direction = Vector2(
		-sin(character.global_rotation.y),
		-cos(character.global_rotation.y)
	)

# Override MoveState move
func move(input_dir: Vector2, delta: float):
	# Add the gravity.
	if not character.is_on_floor():
		character.velocity.y -= character.gravity * delta
	
	var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	character.velocity.x = direction.x * move_speed
	character.velocity.z = direction.z * move_speed


# Override MoveState input() since we don't want to change states based on player input
func input(event: InputEvent) -> BaseState:
	return null

# Move in the dodge_direction every frame
func get_movement_input() -> Vector2:
	return dodge_direction

# Track how long we've been dodgeing so we know when to exit
func process(delta: float) -> BaseState:
	current_dodge_time -= delta

	if current_dodge_time > 0:
		return null

	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		return run_state
	return idle_state
