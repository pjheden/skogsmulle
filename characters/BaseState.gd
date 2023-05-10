class_name BaseState
extends Node

@export var animation_name: String
@export var rifle_animation_name: String


# Pass in a reference to the player's kinematic body so that it can be used by the state
var character: Character

func enter() -> void:
	if character.gun and rifle_animation_name != "":
		character.animation_state_machine.travel(rifle_animation_name)
	elif animation_name != "":
		character.animation_state_machine.travel(animation_name)

func exit() -> void:
	pass

func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("drop") and character.gun:
		character.gun.drop()
		character.gun = null
		character.animation_tree.set("parameters/conditions/equip", false)
		#character.animation_tree.set("parameters/conditions/unequip", true)
		character.busy_hands = false
		
	return null

func process(delta: float) -> BaseState:
	return null

func physics_process(delta: float) -> BaseState:
	return null
