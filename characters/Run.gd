extends MoveState

func enter() -> void:
	super.enter()
	
func input(event: InputEvent) -> BaseState:
	var ev = super.input(event)
	if ev:
		return ev
	
	if Input.is_action_pressed("sneak") and not character.busy_hands:
		return sneak_state


	return null
