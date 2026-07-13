class_name LifeTimer
extends CanvasLayer


@onready var time_bar: ProgressBar = $"../CanvasLayer/TimeBar"

@export var max_time := 30.0
@export var damage_per_tick: int = 1


var current_time := 30.0:
	set(value):
		current_time = clamp(value, 0, max_time)
		

func _process(delta):
	current_time -= delta * damage_per_tick

	if current_time < 0:
		current_time = 0
		time_up()

	time_bar.value = (current_time / max_time) * 100
	
func time_up():
	#print("Acabou o tempo")
	pass

func regainTime(time_regained: float):
	current_time += time_regained
