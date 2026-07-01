class_name AnimationResource
extends Resource

var master: Node2D

@export var y_squish: Vector2
@export var rotation_factor: Vector2


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	pass

func animateIdle() -> void:
	master.scale.y = lerp(master.scale.y, y_squish.y, 0.01)
	
	#print(master.scale.y)
