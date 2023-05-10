extends MoveState

func enter() -> void:
	super.enter()
	character.animation_state_machine.travel("SneakFixed")
	
#	if character.gun:
#		character.gun.equip(character)
#		character.busy_hands = false


func input(event: InputEvent) -> BaseState:
	# First run parent code and make sure we don't need to exit early
	# based on its logic
	var new_state = super.input(event)
	if new_state:
		return new_state
	
	if Input.is_action_just_released("sneak"):
		return run_state
		
	return null
