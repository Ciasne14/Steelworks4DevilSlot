extends Control
var started = false
var clicked = false
var clicked2 = false


		
func load_new_scene():
	var new_scene = load("res://Scenes/slot_machine.tscn")
	var new_scene_instance = new_scene.instantiate()
	get_tree().current_scene.add_child(new_scene_instance)


func _on_button_button_down() -> void:
	$Button.disabled = true
	load_new_scene()
