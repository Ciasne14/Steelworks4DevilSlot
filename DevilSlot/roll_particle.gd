extends Node2D

@onready var debirs1:GPUParticles2D=$Debris1

func _ready() -> void:
	# Start cząstek
	debirs1.emitting = true
	#debris2.emitting = true
	_free_later()
	
func _free_later() -> void:
	var wait_time := 1
	await get_tree().create_timer(wait_time).timeout
	if is_instance_valid(self):
		queue_free()
