extends Node2D

@onready var fireDebris:GPUParticles2D=$FireDebris
@onready var explosionPerSe:GPUParticles2D=$ExplosionPerSe
@onready var smoke:GPUParticles2D=$Smoke
@onready var shrapnelDebris:GPUParticles2D=$ShrapnelDebris


func _ready() -> void:
	# Start cząstek
	fireDebris.emitting = true
	explosionPerSe.emitting = true
	smoke.emitting = true
	shrapnelDebris.emitting = true
	# Błysk światła
	_fade_light()
	# Samodestrukcja po czasie

func _fade_light() -> void:
	# Wyłącz światło po krótkim błysku
	await get_tree().create_timer(0.12).timeout
