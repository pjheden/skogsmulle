extends GPUParticles3D

@export var emitting_time: float = 1.0

var current_emitting_time: float = 0

func _ready():
	emitting = false
	current_emitting_time = emitting_time

func _process(delta):
	if not emitting:
		return
		
	current_emitting_time -= delta

	if current_emitting_time > 0:
		return
	
	restart()
	emitting = false

func start() -> void:
	emitting = true
	current_emitting_time = emitting_time
