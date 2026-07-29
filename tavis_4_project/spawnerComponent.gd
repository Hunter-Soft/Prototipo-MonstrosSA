class_name SpawnerComponent
extends Node2D

signal monster_type_list_changed(type_list: Dictionary)

@onready var game_manager: GameManager = $".."

@export var ready_to_spawn: bool = false
var spawned: bool

var monster_list: Array[MonsterController]
var monster_slot_list: Array[int]

var counted: bool

var monster_types_in_game: MonsterController.monsterType

@export var monster_type_list: Dictionary = {
}

@export_subgroup("Config")
@export_range(0.0,1.0)var chance_to_dupe: float = 1
@export var max_monsters: int = 30
@export var monsters_to_spawn: int = 20
var current_monsters: int
@export var monster_pool: Array[PackedScene]
@export var monster_pool_chance: Array[int]
@export var monster_holer: Node

var to_dupe: bool

func _ready() -> void:
	resetSpawner()

func _process(delta: float) -> void:
	
	#if Input.is_action_just_pressed("shoot"): ready_to_spawn = true
	if !spawned && ready_to_spawn:
		var x = chooseMonsters()
		#print(x)
		spawnEnemies(x, false)
	#pass

#func chooseMonsters() -> Array[PackedScene]:
	#var result: Array[PackedScene] = []
	##var amount_each := monsters_to_spawn / monster_pool.size()
#
	##for i in range(monster_pool.size()):
		##for j in range(amount_each):
			##result.append(monster_pool[i])
	#while result.size() < monsters_to_spawn:
		#result.append(monster_pool.pick_random())
#
	#result.shuffle()
	#monsters_to_spawn = 0
	#return result

func chooseMonsters() -> Array[PackedScene]:
	var result: Array[PackedScene] = []
	for i in range(monsters_to_spawn):
		var total := 0
		for chance in monster_pool_chance:
			total += chance
		var rng := randi_range(1, total)
		var accumulated := 0
		for j in range(monster_pool.size()):
			accumulated += monster_pool_chance[j]
		
			if rng <= accumulated:
				result.append(monster_pool[j])
				break
	monsters_to_spawn = 0
	return result

func spawnEnemies(monster_to_spawn_list: Array[PackedScene], special_case: bool) -> void:
	
		
	
	for monster in monster_to_spawn_list:
		if current_monsters >= max_monsters && !special_case:
			break
	
		var new_monster: Node2D = monster.instantiate()

		var new_position: Vector2= get_spawn_position(50, $"../Marker2D".global_position, $"../Marker2D2".global_position)

		new_monster.global_position = new_position
		new_monster.game_manager = game_manager

		monster_list.append(new_monster)
		$"../==MonsterHolder==".add_child(new_monster)
	
	var urgent_appears_at = 6
	var urgent_rng = randf()
	if urgent_rng <= float(game_manager.current_phase)/30:
		game_manager.order_manager.emergency_order.emit()
		
	#if monster_list[0].monster_type != monster_list[0].monsterType.Urgent: #FILHA DA PUTA ACHEI
	checkTypeNumber()
	get_parent().monster_data_ready.emit()

	spawned = true
	ready_to_spawn = false

func get_spawn_position(min_distance: float, point_01: Vector2, point_02) -> Vector2:
	var new_position: Vector2

	while true:
		new_position = global_position + Vector2(
			randi_range(point_01.x, point_02.x),
			randi_range(point_01.y, point_02.y)
		)

		if is_position_valid(new_position, min_distance):
			return new_position
	return Vector2(0, 0)

func is_position_valid(position: Vector2, min_distance: float) -> bool:
	for monster in monster_list:
		if monster == null:
			continue

		if position.distance_to(monster.global_position) < min_distance:
			return false

	return true
func resetSpawner() -> void:
	#current_monsters = max_monsters
	#spawnEnemies(chooseMonsters())
	
	spawned = false
	ready_to_spawn = true
	pass

func rerollSpawnAmount(monsters_used: int) -> void:
	var count_modifier: int = 0

	if randi_range(0, 1) == 1:
		count_modifier = monsters_used + 2
	else:
		count_modifier = monsters_used - 1

	monsters_to_spawn += count_modifier

	resetSpawner()

func checkTypeNumber() -> void:
	monster_type_list.clear()
	current_monsters = 0

	for monster in monster_list:
		if monster != null:
			current_monsters += 1

	for monster: MonsterController in monster_list:
		if monster == null || monster.monster_type == monster.monsterType.Urgent:
			continue

		monster_type_list[monster.monster_type] = monster_type_list.get(monster.monster_type, 0) + 1

	for type in MonsterController.monsterType.values():
		if !monster_type_list.has(type):
			monster_type_list[type] = 0

	monster_type_list_changed.emit(monster_type_list)
	
func spawn_specific_monster(type: MonsterController.monsterType) -> void:
	var new_monster: Node2D = monster_pool[type].instantiate()

	var new_position: Vector2 = get_spawn_position(
		50,
		$"../Marker2D".global_position,
		$"../Marker2D2".global_position
	)

	new_monster.global_position = new_position

	monster_list.append(new_monster)
	$"../==MonsterHolder==".add_child(new_monster)

	checkTypeNumber()
	
func ensure_monsters_for_order(order: Array) -> void:
	checkTypeNumber()
	var needed := {}
	for type in order:
		needed[type] = needed.get(type, 0) + 1

	for type in needed.keys():
		var available = monster_type_list.get(type, 0)
		while available < needed[type]:
			spawn_specific_monster(type)
			available += 1
