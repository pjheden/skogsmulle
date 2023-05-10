extends Node3D

@onready var spring_arm = $SpringArm3D

var rotating: bool = false

func start_rotation():
	rotating = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func stop_rotation():
	rotating = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
#	if Input.is_action_just_pressed("rotate_camera"):
#		start_rotation()
#	elif Input.is_action_just_released("rotate_camera"):
#		stop_rotation()
		
	if event is InputEventMouseMotion and rotating:
		rotate_y(-event.relative.x * .005)
		spring_arm.rotate_x(-event.relative.y * .005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
