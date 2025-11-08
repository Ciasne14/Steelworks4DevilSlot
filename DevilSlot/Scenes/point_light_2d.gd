extends PointLight2D

# Colors to choose from
var colors : Array = [Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1), Color(1, 1, 1)]

func _ready():
	# Optionally start changing colors when the scene is ready
	set_color_randomly()

func _process(_delta):
	# Randomly change color periodically, for example every 1 second
	if randi_range(0, 10) < 2:  # Roughly change color every 50 frames
		set_color_randomly()

func set_color_randomly():
	color = colors[randi_range(0, colors.size() - 1)]  # Randomly select a color and apply to modulate
