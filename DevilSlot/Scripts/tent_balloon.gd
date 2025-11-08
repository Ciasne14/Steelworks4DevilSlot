extends Area2D
@onready var minigame = "res://Scenes/balloon_poper.tscn"

func _on_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file(minigame)
