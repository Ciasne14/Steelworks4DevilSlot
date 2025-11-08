extends Area2D
@onready var transition = "res://Scenes/main_menu.tscn"

func _on_mouse_entered() -> void:
	get_tree().change_scene_to_file(transition)
	
