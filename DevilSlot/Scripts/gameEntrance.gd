extends Area2D
@onready var transition = "res://Scenes/game.tscn"

func _on_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file(transition)
	
