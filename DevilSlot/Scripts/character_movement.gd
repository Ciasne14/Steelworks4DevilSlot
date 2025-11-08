extends CharacterBody2D


const SPEED = 300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var horizontal_direction := Input.get_axis("left", "right")
	var vertical_direction := Input.get_axis("up", "down")
	
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if horizontal_direction > 0:
		animated_sprite.flip_h = 1
	
	elif horizontal_direction < 0:
		animated_sprite.flip_h = 0
		
	if vertical_direction:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
		animated_sprite.animation = "walking"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.animation = "default"

	move_and_slide()
