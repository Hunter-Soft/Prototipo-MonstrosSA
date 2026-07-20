class_name OrderManager
extends Node2D

signal completed_order
signal mistaken_monster_order
signal right_monster_order

@export var monster_sprites: Array[SpriteFrames]
@export var transparent_clicked_monsters: bool = true

@export var order_size := 2
@export var order_list: Array = []
@export var offset := Vector2(100, 0)

@onready var order_flag_scene: PackedScene = load("res://Objects/Prefabs/orderFlag.tscn")
@onready var correct_particles: PackedScene = load("res://Objects/Components/HitParticles.tscn")
@onready var correct_monster_SFX_scene: PackedScene = load("res://Objects/Components/SFXComponent.tscn")

@onready var spawner_component: SpawnerComponent = $"../SpawnerComponent"
@onready var game_manager: GameManager = get_parent()

func _ready() -> void:
	game_manager.monster_data_ready.connect(randomizeOrder)
	connect("right_monster_order", func():
		if transparent_clicked_monsters:
			for child: Node2D in get_children():
				var child_sprite: AnimatedSprite2D = child.get_child(0)
				if child_sprite.modulate.a == 1:
					child_sprite.modulate.a = 0.15
					return
		#pass
	)
	#completed_order.connect(randomizeOrder)

func randomizeOrder() -> void:
	order_list.clear()
	var available := []
	for type in game_manager.monster_type_list.keys():
		for i in range(game_manager.monster_type_list[type]):
			available.append(type)
	if available.is_empty():
		print("No monsters available.")
		return

	available.shuffle()

	for i in range(order_size):
		if available.is_empty():
			break
		order_list.append(available.pop_back())

	print("Generated order:")
	print(order_list)
	spawner_component.ensure_monsters_for_order(order_list)
	createOrderFlags()

func createOrderFlags() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

	print("GERANDO BANDEIRAS")

	for i in range(order_list.size()):
		var flag_scene: Node2D = order_flag_scene.instantiate()
		var new_flag: AnimatedSprite2D = flag_scene.get_child(0)

		new_flag.sprite_frames = monster_sprites[order_list[i]]
		
		match order_list[i]:
			MonsterController.monsterType.Example_01:
				new_flag.modulate = Color.RED
				
			MonsterController.monsterType.Example_02:
				new_flag.modulate = Color.GREEN
				
			MonsterController.monsterType.Example_03:
				new_flag.modulate = Color.BLUE

		new_flag.scale = Vector2(0.3, 0.3)
		add_child(flag_scene)

	sort_positions()
	for flag in get_children():
		var anim_player: AnimationPlayer = flag.get_child(1)
		anim_player.play("Enter_Scene")


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

	monster.delivered.emit()
	right_monster_order.emit()
	print("Correct!")

	#NICOLLAS
	var new_particles: CPUParticles2D = correct_particles.instantiate()
	new_particles.global_position = monster.global_position
	get_tree().root.add_child(new_particles)

	var new_sfx: AudioStreamPlayer2D = correct_monster_SFX_scene.instantiate()
	new_sfx.global_position = monster.global_position
	get_tree().root.add_child(new_sfx)

	order_list.pop_front()

	if game_manager.monster_type_list.has(clicked_type):
		game_manager.monster_type_list[clicked_type] -= 1

		if game_manager.monster_type_list[clicked_type] <= 0:
			game_manager.monster_type_list.erase(clicked_type)

	monster.queue_free()

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
