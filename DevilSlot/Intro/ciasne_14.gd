extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		# Load the new scene
		queue_free()
