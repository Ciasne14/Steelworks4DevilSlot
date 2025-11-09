extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		# Load the new scene
		var new_scene = load("res://main_menu.tscn")
		var new_scene_instance = new_scene.instantiate()

		# Get the current scene
		var current_scene = get_tree().current_scene
		
		# Remove the current scene
		current_scene.queue_free()  # This will remove the current scene from the tree

		# Add the new scene as the root
		get_tree().root.add_child(new_scene_instance)  # Adds the new scene as a child of the root node
