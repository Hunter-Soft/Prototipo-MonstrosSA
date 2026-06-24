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
@export var monster_to_spawn: int = 20
var current_monsters: int
@export var monster_pool: Array[PackedScene]
@export var monster_pool_chance: Array[int]
@export var monster_holer: Node

func _ready() -> void:
	resetSpawner()

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("shoot"): ready_to_spawn = true
	if !spawned && ready_to_spawn:
		var x = chooseMonsters()
		#print(x)
		spawnEnemies(x)
	#pass
	
func chooseMonsters() -> Array[PackedScene]:
	var monster_to_spawn_list: Array[PackedScene]
	
	#region Criar um dicionário com as chances e os index de cada monstro
	var indexed = []

	for i in range(monster_pool_chance.size()):
		indexed.append({
			"value": monster_pool_chance[i],
			"original_index": i
		})
	#endregion
	
	#region Spawna os monstros quando precisar, no início do jogo spawna 20
	while monster_to_spawn > 0:
		#region Cuida da roleta
		var total_chance = 0
	
		for i in range(0, monster_pool.size()):
			total_chance += monster_pool_chance[i]
		
		var rng = randf() * total_chance
		
		var acumulated_chance = 0
		var chance_index = 0
		
		for monster in indexed:
			#print(monster.value)
			acumulated_chance += monster.value
			if rng < acumulated_chance:
				chance_index = monster.original_index
				break
		#endregion
		
		var current_monster = monster_pool[chance_index]
		monster_to_spawn -= 1
		
		monster_to_spawn_list.append(current_monster)
	#endregion
	return monster_to_spawn_list

func spawnEnemies(monster_to_spawn_list: Array[PackedScene]) -> void:
	for monster in monster_to_spawn_list:
		#var
		var new_monster: Node2D = monster.instantiate()
		new_monster.global_position = global_position + Vector2(randi_range(1, 350), randi_range(1, 350))
		monster_list.append(new_monster)
		$"../==MonsterHolder==".add_child(new_monster)
		await get_tree().create_timer(delay_between_spawns).timeout
	checkTypeNumber()
	spawned = true

func resetSpawner() -> void:
	current_monsters = max_monsters
	spawnEnemies(chooseMonsters())
	pass

func checkTypeNumber() -> void:
	monster_type_list = {}
	for monster: MonsterController in monster_list:
		if monster != null:
			monster_type_list[monster.monster_type] = monster_type_list.get(monster.monster_type, 0) + 1
	
	monster_type_list_changed.emit(monster_type_list)
