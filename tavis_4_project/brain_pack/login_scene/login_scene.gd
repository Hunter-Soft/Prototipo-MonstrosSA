extends Node2D


@onready var loginHttpRequest
@onready var LineEditLoginNode = $LineEditLogin
@onready var LineEditPasswordNode = $LineEditPassword

var loginRequested = false

func _ready():
	loginHttpRequest = load("res://brain_pack/http_request/http_request.tscn").instantiate()
	add_child(loginHttpRequest)
	pass

func sceneCreate(path,parent,name = 'newNode'):
	var nodeClass = path
	var newNode = nodeClass.instantiate()
	newNode.name = name
	parent.add_child(newNode)
	
	return newNode

func loading():
	$Label.text = "Aguarde..."
	$Load.show()
	
func login():
	loginHttpRequest.login(LineEditLoginNode.text, LineEditPasswordNode.text)
	
func startGame():
	
	get_tree().change_scene_to_file("res://brain_pack/callibration_scene/calibration.tscn")
	

func startLogin():
	loading()
	login()
	
func _on_Button_pressed():
	startLogin()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		startLogin()
	
	if Input.is_action_just_pressed("ui_home"):
		startGame()
	
	if loginHttpRequest.getResponse():
		if !loginHttpRequest.logged:
			$Label.text = loginHttpRequest.getMessage()
			$Load.hide()
		else:
			ServerData.currentUsedID = loginHttpRequest.getUserData()
			#Nicollas
			ServerData.generateSectionID()
			#Nicollas
			startGame()
		
