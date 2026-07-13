extends Node

var score = 0
var monkey_focus = 0
var lives = 3

func reset():
	score = 0
	monkey_focus = 0
	lives = 3

func sceneCreate(scene,parent,pos = null,name = null):
	var sceneInstance = scene.instantiate()
	if pos:
		sceneInstance.position = pos
	if name:
		sceneInstance.setName(name)
	parent.add_child(sceneInstance)
	return sceneInstance
