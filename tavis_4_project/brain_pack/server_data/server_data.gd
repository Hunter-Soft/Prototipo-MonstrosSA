extends Node

var alternative_gameover_sfx: bool = false
#var current_grass_sound: String = "res://Sounds/sand step.ogg"

var server := UDPServer.new()
var peers = []
var pkt

var attention = 50
var meditating_value = 40

#Nicollas
var in_game = false
var x_tp
var current_tp_game = 108
var current_meditation
var current_focus
var spanish = false
enum games {JURASSIC, ISLAND, BIKE} 
enum meditation_games {BEACH, SONG}
var current_game = games.ISLAND
var current_meditation_game = meditation_games.SONG
#Nicollas

#Piscada e concentração
var blink = false
var focus = false
#Nicollas
var meditate = false
#Nicollas

var start = false
var arrays
var sectionID

#tempo para absorver dados
var time = 0

#estado manual ou conectado a virtual icc
var virtualIcc = false

var currentUsedID = 0

func setAttention(n):
	attention = int(n)

#Nicollas
func setMeditation(x):
	meditating_value = int(x)
#Nicollas

func generateSectionID():
	var date = Time.get_datetime_dict_from_system()
	sectionID = str(date.year) +"_"+ str(date.month) +"_"+ str(date.day) +"_"+ str(date.weekday) +"_"+ str(date.hour) +"_"+ str(date.minute) +"_"+ str(date.second) 
	data = dataClass.new()
	start = true
	return sectionID
	
var user_data = {
	
	"usuario_id": 0,
	"tempo_concentrado": 0,
	"tempo_distraido": 0,
	"vezes_concentrado": 0,
	"vezes_desconcentrado": 0,
	"score_total": 0,
	"level_final": 0,
	"finalizado": 0,
	"data_levels": [],
	"data_iccs": [],
	"tp_jogo": 402,
	
}

@onready var dataClass = load("res://brain_pack/data_classes/send_data.gd")
@onready var data = dataClass.new()

func getBlink():
	return blink

func getFocus():
	return focus

func _ready():
	#Nicollas
	current_meditation = 100
	#current_focus = 100
	meditate = true
	#focus = true
	#Nicollas
	
	
	server.listen(12345)
	user_data = {}

func save_and_update():
	update_user_data(user_data, data.user, data.focusTime, data.unfocusTime, data.focusBits, data.unfocusBits, data.totalScore, data.lastLevel, data.finished, data.levelData, data.iccData)
	return save_and_serialization_user_data(user_data, data.user)
	
func _process(delta):
	x_tp = user_data.get("tp_jogo")
	
	if Input.is_action_just_pressed("home"):
		get_tree().change_scene_to_file("res://brain_pack/callibration_scene/calibration.tscn")
	if Input.is_action_just_pressed("login"):
		get_tree().change_scene_to_file("res://brain_pack/login_scene/login_scene.tscn")
	
	if start:
		
		if Input.is_action_just_pressed("ui_down"):
			print("usuario_id" ," ", data.user)
			print("tempo_concentrado"," ", data.focusTime)
			print("tempo_distraido"," ", data.unfocusTime)
			print("vezes_concentrado"," ", data.focusBits)
			print("vezes_desconcentrado"," ", data.unfocusBits)
			print("score_total"," ", data.totalScore)
			print("level_final"," ", data.lastLevel)
			print("finalizado"," ", data.finished)
	
	server.poll()
	
	if server.is_connection_available():
		var peer : PacketPeerUDP = server.take_connection()
		pkt = peer.get_packet()
		
		var json_conv = JSON.new()
		json_conv.parse(pkt.get_string_from_utf8())
		arrays = json_conv.get_data()
	
	if arrays:
		if int(arrays.blinkStrength) > 40:
			blink = true
		else:
			blink = false
		
		if in_game:
			data.addIcc(delta,arrays.attention,arrays.meditation,arrays.blinkStrength,arrays.f1,arrays.f2,arrays.f3,arrays.f4,arrays.f5,arrays.f6,arrays.f7,arrays.f8)
		
		#Nicollas
		current_meditation = arrays.meditation
		current_focus = arrays.attention
		Global.score = data.totalScore
		#Nicollas
		
		if int(arrays.attention) > attention:
			
			if start:
				data.focusTime += delta
				if !focus:
					data.focusBits += 1
			
			focus = true
			
		else:
			
			if start:
				data.unfocusTime += delta
				if focus:
					data.unfocusBits += 1
					
			focus = false
		#Nicollas
		print(int(arrays.meditation))
		
		if int(arrays.meditation) > meditating_value:
			meditate = true 
		else:
			meditate = false
		#Nicollas
	else:
		manualControls(delta)
		if virtualIcc:
			data.addIcc(delta,randf_range(0,100),randf_range(0,100),randf_range(0,100),randf_range(0,100),randf_range(0,100),randf_range(0,100),randf_range(0,100),randf_range(0,100),randf_range(0,100),randf_range(0,100),randf_range(0,100))
		
	#print(data.focusTime)
	#print(data.unfocusTime)
	
			
			
func manualControls(delta):
		if Input.is_action_pressed("ui_accept"):
			blink = true
		else:
			blink = false
			
		if Input.is_action_just_pressed("ui_select"):
			if start:
				data.focusBits += 1
		
		if Input.is_action_just_released("ui_select"):
			if start:
				data.unfocusBits += 1
		
		if Input.is_action_pressed("ui_select"):
			focus = true
			if start:
				data.focusTime += delta
		else:
			focus = false
			if start:
				data.unfocusTime += delta
				
		if Input.is_action_just_pressed("ui_page_up"):
			virtualIcc = true
			print("started virtual icc")
			
		if Input.is_action_just_pressed("ui_page_down"):
			virtualIcc = true
			print("stoped virtual icc")
		
	

func update_user_data(user_data, user, focusTime, unfocusTime, focusBits, unfocusBits, totalScore, lastLevel, finished, levelData, iccData):
	
	# Atribui os valores aos campos de 'user_data'
	user_data["usuario_id"] = int(currentUsedID) #user if user != null else 0
	user_data["tempo_concentrado"] = int(focusTime) if focusTime != null else 0
	user_data["tempo_distraido"] = int(unfocusTime) if unfocusTime != null else 0
	user_data["vezes_concentrado"] = int(focusBits) if focusBits != null else 0
	user_data["vezes_desconcentrado"] = int(unfocusBits) if unfocusBits != null else 0
	user_data["score_total"] = int(totalScore) if totalScore != null else 0
	user_data["level_final"] = int(lastLevel) if lastLevel != null else 0
	user_data["finalizado"] = int(finished) if finished != null else 0
	user_data["tp_jogo"] = current_tp_game
	
	user_data["data_iccs"] = []
	for x in iccData.size():
		var icc_data = {
			#"poor_signal_level": 'good',
			"attention": int(iccData[x].attention),
			"meditation":  int(iccData[x].meditation),
			"blink_strength": int(iccData[x].blinkStrength),
			"delta": int(iccData[x].f1),
			"theta": int(iccData[x].f2),
			"low_alpha": int(iccData[x].f3),
			"high_alpha": int(iccData[x].f4),
			"low_beta": int(iccData[x].f5),
			"high_beta": int(iccData[x].f6),
			"low_gamma": int(iccData[x].f7),
			"high_gamma": int(iccData[x].f8)
		}
		user_data["data_iccs"].append(icc_data)
	
	user_data["data_levels"] = []
	for x in levelData.size():
		var level_data = {
			"num": int(levelData[x].level),
			"tempo_concentrado":  int(levelData[x].focusTime),
			"score": int(levelData[x].levelScore),
		}
		user_data["data_levels"].append(level_data)

func save_and_serialization_user_data(user_data, user):
	
	var user_folder = "user://" + str(data.user)
	var dir = DirAccess.open("user://")
	
	if !dir.dir_exists_absolute(user_folder):
		dir.make_dir(str(data.user))
		
	var file_name = user_folder + "/" + sectionID +".json"
	var json_str = JSON.new().stringify(user_data)
	
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(json_str)
	
	return json_str
	
	
