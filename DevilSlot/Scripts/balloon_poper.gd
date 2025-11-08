extends Node2D

@export var balloon_scene: PackedScene
@export var spawn_interval := 1.2
@export var max_lives := 3

var score := 0
var lives := 3
var spawn_timer := 0.0

@onready var score_label := $CanvasLayer/ScoreLabel
@onready var lives_label := $CanvasLayer/LivesLabel
@onready var balloons_root := $Balloons
@onready var restart_btn := $CanvasLayer/RestartButton

func _ready():
	restart_btn.pressed.connect(_on_restart_pressed)
	_reset_game()

func _process(delta):
	spawn_timer -= delta
	if spawn_timer <= 0:
		_spawn_balloon()
		spawn_timer = randf_range(spawn_interval * 0.6, spawn_interval * 1.4)

func _spawn_balloon():
	if balloon_scene == null:
		push_warning("Balloon scene not assigned!")
		return
	var b = balloon_scene.instantiate()
	var screen_size = get_viewport_rect().size
	b.position = Vector2(randf_range(100, screen_size.x - 100), screen_size.y + 50)
	$Balloons.add_child(b)

func add_score(points: int):
	score += points
	_update_ui()

func lose_life():
	lives -= 1
	_update_ui()
	if lives <= 0:
		_game_over()

func _update_ui():
	score_label.text = "Wynik: %d" % score
	lives_label.text = "Życia: %d" % lives

func _reset_game():
	score = 0
	lives = max_lives
	_update_ui()
	for child in balloons_root.get_children():
		child.queue_free()

func _game_over():
	for child in balloons_root.get_children():
		child.queue_free()

func _on_restart_pressed():
	_reset_game()

# 🖱️ kliknięcie w balon
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var click_pos = event.position
		var clicked_balloon := _get_clicked_balloon(click_pos)
		if clicked_balloon:
			clicked_balloon.pop()

func _get_clicked_balloon(pos: Vector2) -> Node:
	for b in $Balloons.get_children():
		if b.has_node("CollisionShape2D"):
			var shape = b.get_node("CollisionShape2D").shape
			if shape is CircleShape2D:
				var dist = b.global_position.distance_to(pos)
				if dist < shape.radius * b.scale.x:
					return b
	return null
