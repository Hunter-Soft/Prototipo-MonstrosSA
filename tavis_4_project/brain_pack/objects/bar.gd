extends Node2D

var focusT = 0

func charge(delta, maintain = false):
	if ServerData.getFocus():
		focusT += delta * 30
		if focusT > 1:
			$Think.play()
			focusT = 0
		
		if $fullBar.scale.x < 1:
			$fullBar.scale.x += delta
		else:
			if !maintain:
				$fullBar.scale.x = 0
			else:
				$fullBar.scale.x = 1
			
			return true
		
	else:
		$fullBar.scale.x = 0
	
