extends Item

@export var back_position_bias: Vector3 = Vector3(0, -0.35, 0)
@export var rotation_bias: Vector3 = Vector3(0, -0.35, 0)

@onready var smoke = $Emitters/Smoke
@onready var muzzle_flash = $Emitters/MuzzleFlash

func shoot() -> bool:
	if !is_ready:
		return false
	
	smoke.start()
	muzzle_flash.start()
	
	is_ready = false
	cd.start()
	
	return true

func show_item():
	visible = true

func hide_item():
	visible = false
	smoke.stop()
	muzzle_flash.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_status == STATUS.FREE:
		rotate_y(delta)
		return
	
	if current_status == STATUS.USING or current_status == STATUS.EQUIPPED:
		# Put in both hands
		var right_transform: Transform3D = target.get_right_hand_transform()
		var left_transform: Transform3D = target.get_left_hand_transform()
		
		global_position = right_transform.origin
		
		look_at(left_transform.origin)
		rotation += rotation_bias
