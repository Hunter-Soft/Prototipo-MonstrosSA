class_name OrderManager
extends Node2D

signal completed_order
signal mistaken_monster_order
signal right_monster_order

@export var monster_sprites: Array[SpriteFrames]
@export var transparent_clicked_monsters: bool = true

@export var order_size := 3
@export var order_list: Array = []
@export var offset := Vector2(150, 0)

@onready var order_flag_scene: PackedScene = load("res://Objects/Prefabs/orderFlag.tscn")

@onready var spawner_component: SpawnerComponent = $"../SpawnerComponent"
@onready var game_manager: GameManager = get_parent()

func _ready() -> void:
	game_manager.monster_data_ready.connect(randomizeOrder)
	connect("right_monster_order", func():
		if transparent_clicked_monsters:
			for child: AnimatedSprite2D in get_children():
				if child.modulate.a == 1:
					child.modulate.a = 0.15
					return
		#pass
	)
	#completed_order.connect(randomizeOrder)

func randomizeOrder() -> void:
	order_list.clear()
	
	var available := game_manager.monster_type_list.duplicate()

	for i in range(order_size):
		var valid_types := []
		for type in available.keys():
			if available[type] > 0:
				valid_types.append(type)

		if valid_types.is_empty():
			break

		var chosen_type = valid_types.pick_random()
		order_list.append(chosen_type)
		available[chosen_type] -= 1

	print("Generated order:")
	print(order_list)
	createOrderFlags()

func createOrderFlags() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	print("GERANDO BANDEIRAS")

	for i in range(order_list.size()):
		var new_flag: AnimatedSprite2D = order_flag_scene.instantiate()

		new_flag.sprite_frames = monster_sprites[order_list[i]]
		
		match order_list[i]:
			MonsterController.monsterType.Example_01:
				new_flag.modulate = Color.RED
				
			MonsterController.monsterType.Example_02:
				new_flag.modulate = Color.GREEN
				
			MonsterController.monsterType.Example_03:
				new_flag.modulate = Color.BLUE

		new_flag.scale = Vector2(0.3, 0.3)
		add_child(new_flag)

	sort_positions()


func sort_positions() -> void:
	print("XXXXX")
	var children = get_children(false)
	var start_x = -offset.x * (children.size() - 1) * 0.5 + 640
	print(start_x)
	print(children.size()-1)

	for i in range(children.size()):
		children[i].position = Vector2(start_x + i * offset.x, 680)

func selectMonster(monster: MonsterController) -> void:
	if order_list.is_empty():
		return

	var clicked_type = monster.monster_type
	var expected_type = order_list[0]

	print("Clicked:", clicked_type)
	print("Expected:", expected_type)

	if clicked_type != expected_type:
		print("Wrong monster!")
		mistaken_monster_order.emit()
		return
		
	var last_monster = order_list.size() == 1
	right_monster_order.emit()
	print("Correct!")

	order_list.pop_front()

	if game_manager.monster_type_list.has(clicked_type):
		game_manager.monster_type_list[clicked_type] -= 1

		if game_manager.monster_type_list[clicked_type] <= 0:
			game_manager.monster_type_list.erase(clicked_type)

	monster.queue_free()
	
	if !last_monster:
		get_parent().click_sound.play()

	print("Remaining order:")
	print(order_list)

	if order_list.is_empty():
		print("ORDER COMPLETED!")
		completed_order.emit()

func getCurrentTarget():
	if order_list.is_empty():
		return null
	
	return order_list[0]

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

func checkOrderCompletion() -> void:
	print("Current order:", order_list)
