class_name SpawnerComponent
extends Node2D

signal monster_type_list_changed(type_list: Dictionary)

@export var ready_to_spawn: bool = false
var spawned: bool

var monster_list: Array[MonsterController]
var monster_slot_list: Array[int]

var counted: bool

@export var monster_type_list: Dictionary = {
}

@export_subgroup("Config")
@export var delay_between_spawns: float = 1
@export var max_monsters: int = 30
@export var initial_monster: int = 20
var current_monsters: int
@export var monster_pool: Array[PackedScene]
@export var monster_pool_chance: Array[int]
@export var monster_holer: Node

func _ready() -> void:
	resetSpawner()

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("shoot"): ready_to_spawn = true
	if !spawned && ready_to_spawn:
		#print(selectMonsters())
		spawnEnemies(selectMonsters())
	#pass

func selectMonsters() -> Array[PackedScene]:
	var indexed = []

	for i in range(monster_pool_chance.size()):
		indexed.append({
			"value": monster_pool_chance[i],
			"original_index": i
		})

	indexed.sort_custom(func(a, b):
		return a["value"] < b["value"]
	)
	
	var monster_to_spawn_list: Array[PackedScene]
	
	while initial_monster < 0:
		var random_index = randi_range(1, monster_pool.size()) - 1
		for key in indexed:
			if key["value"] >= random_index:
				break
		var current_monster = monster_pool[random_index]
		initial_monster -= 1
		
		monster_to_spawn_list.append(current_monster)
	
	return monster_to_spawn_list

func spawnEnemies(monster_to_spawn_list: Array[PackedScene]) -> void:
	for monster in monster_to_spawn_list:
		#var
		var new_monster: Node2D = monster.instantiate()
		new_monster.global_position = global_position + Vector2(randi_range(1, 150), randi_range(1, 150))
		monster_list.append(new_monster)
		$"../==MonsterHolder==".add_child(new_monster)
		await get_tree().create_timer(delay_between_spawns).timeout
	checkTypeNumber()
	spawned = true

func resetSpawner() -> void:
	current_monsters = max_monsters
	spawnEnemies(selectMonsters())
	pass

func checkTypeNumber() -> void:
	monster_type_list = {}
	for monster: MonsterController in monster_list:
		if monster != null:
			monster_type_list[monster.monster_type] = monster_type_list.get(monster.monster_type, 0) + 1
	
	monster_type_list_changed.emit(monster_type_list)
