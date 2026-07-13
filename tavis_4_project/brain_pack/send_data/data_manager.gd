extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Score.text = str(int(Global.score))
	$Ses.text = str(ServerData.currentUsedID) + " : " + str(ServerData.sectionID)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $HTTPRequest.getResponse():
		$Label5.text = str($HTTPRequest.message)
		$HTTPRequest.received = false
		$Load.hide()


func _on_button_button_down():
	$HTTPRequest.save_document(ServerData.save_and_update())
	$Label5.text = "Enviando..."
	$Load.show()


func _on_button_2_button_down():
	ServerData.generateSectionID()
	#get_tree().change_scene_to_file("res://brain_pack/login_scene/login_scene.tscn")
	get_tree().change_scene_to_file("res://brain_pack/callibration_scene/calibration.tscn")
	Global.reset()
	#$Label5.text = "FECHE A JANELA DO JOGO HEHE!"
	pass # Replace with function body.
