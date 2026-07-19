class_name LifeTimer
extends CanvasLayer


@onready var time_bar: ProgressBar = $"../CanvasLayer/TimeBar"
@onready var game_manager: GameManager = $".."

#@export var max_time := 30.0
#@export var damage_per_tick: int = 1
@export var game_over_called := false
@onready var main_music: AudioStreamPlayer = $"../Music"
@onready var game_over: AudioStreamPlayer = $"../GameOver"


var current_time := 30.0:
	set(value):
		current_time = clamp(value, 0, game_manager.max_time)
		

func _process(delta):
	if game_over_called:
		return
		
	current_time -= delta * game_manager.damage_per_second

	if current_time <= 0:
		current_time = 0
		game_over_called = true
		time_up()

	time_bar.value = (current_time / game_manager.max_time) * 100
	
func time_up():
	game_over.play()
	ServerData.in_game = false
	main_music.stop()
	$"../Game_Over".visible = true
	#print("Acabou o tempo")
	pass

func regainTime(time_regained: float):
	current_time += time_regained
	
func loseTime(time_lost: float):
	current_time -= time_lost
