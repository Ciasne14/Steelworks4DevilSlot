# Global.gd (Autoload)
extends Node

var player_node

func _ready():
	var new_scene = load("res://Intro/ciasne_14.tscn")
	if new_scene:
		var scene_instance = new_scene.instantiate()
		get_tree().root.add_child.call_deferred(scene_instance)
	else:
		print("Failed to load scene.")
