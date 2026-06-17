class_name SpawnerComponent
extends Node2D

@export var ready_to_spawn: bool = false
var spawned: bool

var monster_list: Array[MonsterController]
var monster_slot_list: Array[int]

var counted: bool

@export var monster_type_list: Dictionary = {
}

@export_subgroup("Config")
@export var delay_between_spawns: float = 1
@export var max_points: int = 30
var points: int
@export var enemy_pool: Array[PackedScene]
@export var enemy_pool_cost: Array[int]

func _ready() -> void:
	resetSpawner()

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("shoot"): ready_to_spawn = true
	if !spawned && ready_to_spawn:
		#print(selectEnemies())
		spawnEnemies(selectEnemies())
	#pass

func selectEnemies() -> Array[PackedScene]:
	var enemy_list: Array[PackedScene]
	
	while points > 0:
		var random_index = randi_range(1, enemy_pool.size()) - 1
		var current_enemy = enemy_pool[random_index]
		points -= enemy_pool_cost[random_index]
		
		enemy_list.append(current_enemy)
	
	#for monster in enemy_list:
		#monster_list.append(monster)
	return enemy_list

func spawnEnemies(enemy_list: Array[PackedScene]) -> void:
	for monster in enemy_list:
		#var
		var new_monster: Node2D = monster.instantiate()
		new_monster.global_position = global_position + Vector2(randi_range(1, 150), randi_range(1, 150))
		monster_list.append(new_monster)
		$"../==MonsterHolder==".add_child(new_monster)
		await get_tree().create_timer(delay_between_spawns).timeout
	checkTypeNumber()
	spawned = true

func resetSpawner() -> void:
	points = max_points
	spawnEnemies(selectEnemies())
	pass

func checkTypeNumber() -> void:
	#counted = true
	monster_type_list = {}
	#var count: int = 0
	for monster: MonsterController in monster_list:
		#if
		if monster != null:
			#if !counted:
				#monster_type_list[monster.monster_type] = 0
			monster_type_list[monster.monster_type] = monster_type_list.get(monster.monster_type, 0) + 1
		
	#
	#var count = 0
	#for monster: MonsterController in monster_list:
		#if monster != null && monster.monster_type == 0:
			#count += 1
			##monster_type_list["type_1"] += 1
	#monster_type_list["type_1"] = count
	#
	#count = 0
	#
	#for monster: MonsterController in monster_list:
		#if monster != null && monster.monster_type == 1:
			#count += 1
			##monster_type_list["type_1"] += 1
	#monster_type_list["type_2"] = count
#
#class EnemyData:
	#var x
	#var y
