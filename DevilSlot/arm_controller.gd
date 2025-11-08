extends Sprite2D


@export var sprite: = Sprite2D # Referencja do twojego sprite'a
var scale_factor = 1.0  # Początkowy współczynnik skali
var pulsate_speed = 2.0  # Prędkość pulsowania (wyższa wartość = szybsze pulsowanie)
var scale_range = 0.2  # Zmiana skali o 20% (0.2 to 20%)
var time_accumulator = 0.0  # Czas akumulowany

func _ready() -> void:
	var randomera = randi_range(1,2)
	if (randomera==1):
		scale_factor = -1
		pulsate_speed = -1
		scale_range = -.2
		
func _process(delta):
	# Akumulujemy czas w zmiennej time_accumulator
	time_accumulator += delta * pulsate_speed
	
	# Lerp: płynne przejście między wartościami skali
	scale_factor = lerp(1.0, 1.0 + scale_range, 0.5 * (sin(time_accumulator) + 1))
	
	# Zastosowanie nowej skali do sprite'a
	sprite.scale = Vector2(scale_factor, scale_factor)
