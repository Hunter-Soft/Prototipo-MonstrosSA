extends Node

#User example
var user = 1
var focusTime = 0
var unfocusTime = 0
var focusBits = 0
var unfocusBits = 0
var totalScore = 0
var lastLevel = 0
var finished = 0

var levelData = []
var iccData = []

var timeout = 0

func addLevel(l,f,s):
	var levelClass = load("res://brain_pack/data_classes/level_data.gd")
	var level = levelClass.new()
	level.init(l,f,s)
	levelData.append(level)

func addIcc(d,a,m,b,f1,f2,f3,f4,f5,f6,f7,f8):
	
	timeout += d
	if timeout >= 1:
		print("tic")
		timeout = 0
		var iccClass = load("res://brain_pack/data_classes/icc_data.gd")
		var icc = iccClass.new()
		icc.init(a,m,b,f1,f2,f3,f4,f5,f6,f7,f8)
		iccData.append(icc)
	
