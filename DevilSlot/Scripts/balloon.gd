extends Area2D

@export var float_speed := -80.0
@export var pop_score := 10

func _physics_process(delta):
	position.y += float_speed * delta
	if position.y < -100:
		var game = get_tree().current_scene
		if game.has_method("lose_life"):
			game.lose_life()
		queue_free()

func pop():
	var game = get_tree().current_scene
	if game.has_method("add_score"):
		game.add_score(pop_score)
	queue_free()
