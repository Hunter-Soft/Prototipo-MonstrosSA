class_name OrderManager
extends Node2D

signal completed_order
signal mistaken_order

@onready var game_manager: GameManager = get_parent()

@export var image: SpriteFrames
@export var order_list: Dictionary = {}

func _ready() -> void:
	$"../Button".connect("pressed", checkOrderCompletion)

	game_manager.monster_data_ready.connect(randomizeOrder)

	connect("completed_order", randomizeOrder)

func randomizeOrder() -> void:
	order_list.clear()

	for monster_type in game_manager.monster_type_list.keys():
		var available = game_manager.monster_type_list[monster_type]

		if available > 0:
			order_list[monster_type] = randi_range(0, available)

	print("Pedido gerado:", order_list)
	print("Tipos disponíveis:", game_manager.monster_type_list)

	updateIndicator()

func updateIndicator() -> void:
	var index := 0

	for indicator in get_children():
		if index >= order_list.keys().size():
			break

		var monster_type = order_list.keys()[index]

		if indicator.get_child_count() > 1:
			indicator.get_child(1).text = str(order_list[monster_type])

		index += 1
		
func selectMonster(monster: MonsterController) -> void:
	var type = monster.monster_type

	print("Tipo clicado:", type)
	print("Pedido atual:", order_list)

	if !order_list.has(type):
		print("Tipo não está no pedido bicho burro")
		return

	order_list[type] -= 1
	print("Pedido atualizado:", order_list)

	monster.queue_free()

	updateIndicator()

	checkOrderFinished()
	
func checkOrderFinished() -> void:
	for amount in order_list.values():
		if amount > 0:
			return

	completed_order.emit()
	print("PEDIDO COMPLETO DISGRASSA")

func checkOrderCompletion() -> void:
	print("Pedido:", order_list)

	completed_order.emit()
	print("EEEEEEEEEEEEE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
