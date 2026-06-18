extends CanvasLayer


@onready var time_bar: ProgressBar = $"../CanvasLayer/TimeBar"

@export var max_time := 30.0

var current_time := 30.0

func _process(delta):
	current_time -= delta

	if current_time < 0:
		current_time = 0
		time_up()

	time_bar.value = (current_time / max_time) * 100
	
func time_up():
	print("Hachimi cabo mambo")
