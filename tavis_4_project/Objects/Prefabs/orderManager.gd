class_name OrderManager
extends Node2D

signal completed_order
signal mistaken_order

@onready var delivery_area: DeliveryZone = $"../DeliveryArea"

@export var image: SpriteFrames
@export var order_list: Dictionary = {
	"type_1": 0,
	"type_2": 0
}

func _ready() -> void:
	$"../Button".connect("pressed", checkOrderCompletion)
	randomizeOrder()
	connect("completed_order", randomizeOrder)
	pass # Replace with function body.

func randomizeOrder() -> void:
	for i in range(order_list.size()):
		order_list["type_%d" % (i+1)] = randi_range(1, 3)
	
	updateIndicator()

func updateIndicator() -> void:
	var x = 1
	for i in get_children():
		i.get_child(1).text = str(order_list["type_%d" % x])
		x += 1

func checkOrderCompletion() -> void:
	if delivery_area.monster_type_list == order_list:
		completed_order.emit()
		print("BOA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	else:
		mistaken_order.emit()
		print("BUROOOOOOOOOOOOOOOOOOO")
	pass
