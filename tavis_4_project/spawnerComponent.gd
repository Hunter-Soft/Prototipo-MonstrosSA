extends Node2D

@export var ready_to_spawn: bool = false
var spawned: bool

@export_subgroup("Config")
@export var delay_between_spawns: float = 0.15
@export var points: int = 12
@export var enemy_pool: Array[PackedScene]
@export var enemy_pool_cost: Array[int]

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
	
	return enemy_list

func spawnEnemies(enemy_list: Array[PackedScene]) -> void:
	for x in enemy_list:
		#var
		var new_enemy: Node2D = x.instantiate()
		new_enemy.global_position = global_position + Vector2(randi_range(1, 150), randi_range(1, 150))
		get_tree().root.add_child(new_enemy)
	pass
	await get_tree().create_timer(delay_between_spawns).timeout

class EnemyData:
	var x
	var y
