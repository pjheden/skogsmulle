class_name Character
extends CharacterBody3D


const CAMERA_ROTATION_SPEED = 30.0

@onready var camera_rig = $CameraRig
@onready var spring_arm = $CameraRig/SpringArm3D
@onready var camera := $CameraRig/SpringArm3D/Camera
@onready var animations = $model/AnimationPlayer
@onready var animation_tree: AnimationTree = $model/AnimationTree
@onready var animation_state_machine = animation_tree["parameters/playback"]
@onready var states = $StateManager

@onready var skeleton: Skeleton3D = $model/Armature/Skeleton3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var gun: Item = null
var busy_hands: bool = false

func _ready():
	camera_rig.top_level = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	states.init(self)

# TODO: move to camera script
func camera_follows_player():
	var player_pos = global_transform.origin
	camera_rig.position = player_pos

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if event is InputEventMouseMotion:
		#rotate_y(-event.relative.x * .005)
		camera_rig.rotate_y(-event.relative.x * .005)
		spring_arm.rotate_x(-event.relative.y * .005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, PI/2)
		
	states.input(event)

func _physics_process(delta):
	camera_follows_player()
	
	animation_tree.set("parameters/IdleRunBlend/blend_position", velocity.length() / 10.0)
	animation_tree.set("parameters/IdleRunRifleBlend/blend_position", velocity.length() / 10.0)
	
	states.physics_process(delta)
	
func _process(delta: float) -> void:
	states.process(delta)
	
# Bone helpers
func get_bone_transform(bone_name: String) -> Transform3D:
	var bone_index: int = skeleton.find_bone(bone_name)
	
	return skeleton.global_transform * skeleton.get_bone_global_pose_no_override(bone_index)
	
func get_left_hand_transform() -> Transform3D:
	return get_bone_transform("mixamorig_LeftHand")
	
func get_right_hand_transform() -> Transform3D:
	return get_bone_transform("mixamorig_RightHand")
