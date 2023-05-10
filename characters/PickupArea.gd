extends Area3D

@onready var character = $".."

func try_pickup() -> void:
	for body in get_overlapping_bodies():
		if not body.is_in_group("pickupable"):
			continue
		
		var equipped = body.try_equip(character)
		if not equipped:
			continue
		
		# TODO: this currently only support guns
		character.gun = body
		character.busy_hands = true
		character.animation_tree.set("parameters/conditions/equip", true)
		#character.animation_tree.set("parameters/conditions/unequip", false)
		character.gun.use()
		break # only pickup 1 at the time

func _unhandled_input(event):
	if Input.is_action_just_pressed("pickup"):
		try_pickup()
