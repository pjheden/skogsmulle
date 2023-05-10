class_name Item
extends RigidBody3D

@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var emitters: Node3D = $Emitters
@onready var cd: Timer = $CD

enum STATUS {FREE, EQUIPPED, USING} 

var current_status: STATUS
var target: CharacterBody3D
var is_ready: bool

func _ready():
	current_status = STATUS.FREE
	is_ready = true

func try_equip(target: CharacterBody3D) -> bool:
	if current_status != STATUS.FREE:
		return false
		
	equip(target)
	
	return true

func equip(t: CharacterBody3D) -> void:
	target = t
	current_status = STATUS.EQUIPPED
	collision.disabled = true
#	for child in emitters.get_children():
#		var emitter: GPUParticles3D = child
#		emitter.restart()
#		emitter.emitting = false
	hide()

func drop() -> void:
	target = null
	current_status = STATUS.FREE
	collision.disabled = false
	show()

func use() -> void:
	current_status = STATUS.USING
	show()
	


func _on_cd_timeout():
	is_ready = true
