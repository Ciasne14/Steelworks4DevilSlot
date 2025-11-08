extends Control
var started = false
func _input(event):
	if event is InputEventKey and event.pressed && !started:
		load_new_scene()
		started=true
		
func load_new_scene():
	var new_scene = load("res://Scenes/slot_machine.tscn")
	var new_scene_instance = new_scene.instantiate()
	get_tree().current_scene.add_child(new_scene_instance)
