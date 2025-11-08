extends Node2D

@onready var smoke:GPUParticles2D=$Smoke


func _ready() -> void:
	# Start cząstek
	smoke.emitting = true
	# Błysk światła
	_fade_light()
	# Samodestrukcja po czasie

func _fade_light() -> void:
	# Wyłącz światło po krótkim błysku
	await get_tree().create_timer(0.12).timeout
