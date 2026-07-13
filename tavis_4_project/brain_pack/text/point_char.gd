extends Label

var jumping = -4
var blink = false
var blinkT = 0

func jump():
	show()
	
func _process(delta):
	if blink:
		blinkT += delta * 30
		if int(blinkT)%2:
			hide()
		else:
			show()
			
	elif visible:
		position.y += jumping
		jumping += delta * 8
		if position.y > 0:
			blink = true
	
	
			
	
