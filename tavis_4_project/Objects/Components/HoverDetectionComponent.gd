class_name HoverDetectionComponent
extends Area2D

signal clicked(object_clicked: Node2D)

#@export var col: Shape2D
@export var hovered: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect("mouse_entered", onHover)
	#connect("mouse_exited", onUnhover)
	connect("input_event", checkInput)
	pass # Replace with function body.
#
#func onHover() -> void:
	#hovered = true
#
#func onUnhover() -> void:
	#hovered = false

func checkInput(viewport: Node, event: InputEvent, shape: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			clicked.emit(self)
			#print("X")
