extends Node2D

var start = false
var level = 0
var focus = 0
var score = 0

var focusT = 0

func _ready():
	$Label8.text = "User: " +str(ServerData.currentUsedID) +" : " +str(ServerData.generateSectionID())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if ServerData.getFocus():
		focus += delta
		$Label6.text = "focus: "+str(int(focus))
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
	
	if ServerData.virtualIcc:
		$Label2.text = "Simulando dados de icc.."
		
	else:
		$Label2.text = "Sem simulação de dados"
	
	if ServerData.start:
		$Label2.text = "Icc em uso detectada!"
		focus += delta

func _on_button_button_down():
	level += 1
	score = randi_range(0,100)
	ServerData.data.addLevel(level,focus,score)
	$Label4.text = "level: "+str(level)
	$Label5.text = "score: "+str(score)
	
	
func _on_button_2_button_down():
	get_tree().change_scene_to_file("res://brain_pack/send_data/data_manager.tscn")
	
	
