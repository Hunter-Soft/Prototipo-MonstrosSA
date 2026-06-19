class_name OrderManager
extends Node2D

signal completed_order
signal mistaken_order

@onready var game_manager: GameManager = get_parent()

@onready var labels := [
	$Label1,
	$Label2,
	$Label3
]

@export var order_list: Dictionary = {}

func _ready() -> void:
	$"../Button".connect("pressed", checkOrderCompletion)

	game_manager.monster_data_ready.connect(randomizeOrder)

	connect("completed_order", randomizeOrder)

func randomizeOrder() -> void:
	order_list.clear()
	var valid_types := []
	for monster_type in game_manager.monster_type_list.keys():
		if game_manager.monster_type_list[monster_type] > 0:
			valid_types.append(monster_type)

	if valid_types.is_empty():
		print("Não existem mais monstros.")
		return

	var monsters_in_order := randi_range(
		1,
		min(3, valid_types.size())
	)

	valid_types.shuffle()

	for i in range(monsters_in_order):
		var monster_type = valid_types[i]
		var available = game_manager.monster_type_list[monster_type]

		order_list[monster_type] = randi_range(1, available)

	print("Pedido gerado:", order_list)
	update_labels()

func update_labels() -> void:
	for label in labels:
		label.text = ""

	var index := 0

	for monster_type in order_list.keys():
		if index >= labels.size():
			break

		var amount = order_list[monster_type]

		labels[index].text = (
			get_monster_name(monster_type)
			+ " x"
			+ str(amount)
		)

		index += 1

func get_monster_name(type) -> String:
	match type:
		MonsterController.monsterType.Example_01:
			return "monto01"

		MonsterController.monsterType.Example_02:
			return "monto02"

		MonsterController.monsterType.Example_03:
			return "monto03"

		_:
			return "??? bro"

func selectMonster(monster: MonsterController) -> void:
	var type = monster.monster_type

	print("Cliquei nessa bomba:", type)
	print("Pedido:", order_list)

	if !order_list.has(type):
		print("Monstro não faz parte do pedido do mcdonalsd.")
		return

	if order_list[type] <= 0:
		return

	order_list[type] -= 1

	if game_manager.monster_type_list.has(type):
		game_manager.monster_type_list[type] -= 1

		if game_manager.monster_type_list[type] <= 0:
			game_manager.monster_type_list.erase(type)

	update_labels()
	monster.queue_free()
	checkOrderFinished()

func checkOrderFinished() -> void:
	for amount in order_list.values():
		if amount > 0:
			return

	print("PEDIDO COMPLETO! BAKUSHINNNNNNNNNN")
	completed_order.emit()

func checkOrderCompletion() -> void:
	print("Pedido atual:", order_list)
