extends Control

@onready var c = $".."

@onready var state = $"GridContainer/State"
@onready var pos = $"GridContainer/Position"
@onready var rot = $"GridContainer/Rotation"

func _process(delta):
	pos.text = str(c.global_position)
	rot.text = str(c.global_rotation)

func _on_state_manager_transitioned(state_name):
	state.text = state_name
