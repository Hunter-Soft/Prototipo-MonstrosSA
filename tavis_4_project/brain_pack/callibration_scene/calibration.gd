extends Node2D

var focusT = 0

func _ready() -> void:
	#if ServerData.current_game == ServerData.games.JURASSIC:
		#$Jurassic.button_pressed = true
	#if ServerData.current_game == ServerData.games.BIKE:
		#$Bike.button_pressed = true
	#if ServerData.current_game == ServerData.games.ISLAND:
		#$Island.button_pressed = true
		#
	#if ServerData.current_meditation_game == ServerData.meditation_games.SONG:
		#$Song.button_pressed = true
	#if ServerData.current_meditation_game == ServerData.meditation_games.BEACH:
		#$Beach.button_pressed = true
	#
	#if ServerData.spanish:
		#$CheckBox.button_pressed = true
		pass

func _process(delta):
	
	
	#if $Jurassic.button_pressed:
		#ServerData.current_game = ServerData.games.JURASSIC
	#if $Bike.button_pressed:
		#ServerData.current_game = ServerData.games.BIKE
	#if $Island.button_pressed:
		#ServerData.current_game = ServerData.games.ISLAND
	#
	#if $Song.button_pressed:
		#ServerData.current_meditation_game = ServerData.meditation_games.SONG
	#if $Beach.button_pressed:
		#ServerData.current_meditation_game = ServerData.meditation_games.BEACH
	#if $Beach.button_pressed:
		#$Beach.button_pressed = true
	#if $Song.button_pressed:
		#$Song.button_pressed = true
	#
	#if $CheckBox.button_pressed:
		#ServerData.spanish = true
	#else:
		#ServerData.spanish = false
	#ServerData
	if ServerData.arrays:
		$Conection.hide()
	else:
		if int(randf_range(1,3))%2 == 0:
			$Conection.hide()
		else:
			$Conection.show()
		
	if ServerData.getBlink():
		$ColorRect2.hide()
		
	if ServerData.getFocus():
		focusT += delta * 30
		if focusT > 1:
			$Bar/Think.play()
			focusT = 0
		
		if $Bar/fullBar.scale.x < 1:
			$Bar/fullBar.scale.x += delta
		else:
			$Bar/fullBar.scale.x = 0
		
	else:
		$Bar/fullBar.scale.x = 0
		
func _on_button_button_down():
	ServerData.setAttention($LineEdit.text)
	ServerData.setMeditation($LineEdit2.text)
	get_tree().change_scene_to_file("res://Meditation/Scenes/Menu.tscn")

func _on_config_button_pressed() -> void:
	#$Config_button.disabled = false
	if !$Config_button/Config.visible:
		$Config_button.disabled = true
	else:
		$Config_button.disabled = false
	$Config_button/Config.visible = !$Config_button/Config.visible
	$Config_button/Config/AudioStreamPlayer2D.stop()
	pass # Replace with function body.


func _on_playaudio_pressed() -> void:
	pass # Replace with function body.


func _on_grass_type_pressed(extra_arg_0: bool) -> void:
	ServerData.alternative_gameover_sfx = extra_arg_0
	#$Config_button/Config/AudioStreamPlayer2D.stream = load(ServerData.current_grass_sound)
	#$Config_button/Config/AudioStreamPlayer2D.play()
	pass # Replace with function body.
