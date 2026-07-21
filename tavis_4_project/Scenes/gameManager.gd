class_name GameManager
extends Node2D

signal monster_data_ready

@onready var click_sound: AudioStreamPlayer = $ClickSound
@onready var complete_sound: AudioStreamPlayer = $CompleteSound
@onready var wrong_sound: AudioStreamPlayer = $WrongSound
@onready var level_label: Label = $Level
@onready var score_label: Label = $Score

#@onready var delivery_area: DeliveryZone = $DeliveryArea
#@onready var delivery_zone: CollisionShape2D = $DeliveryArea/DeliveryZone
@onready var life_timer: LifeTimer = $CanvasLayer
@onready var order_manager: OrderManager = $OrderManager
@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@export var monster_type_list: Dictionary

@export_subgroup("Timer")
@export var max_time: float = 30
@export var damage_per_second: float = 1
@export var time_regen: float = 10

var current_phase := 1
var level: int = 1
var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ServerData.in_game = true
	
	spawner_component.connect("monster_type_list_changed", func(type_list):
		monster_type_list = type_list
		print("Monstros disponíveis:", monster_type_list)
	)
	
	order_manager.connect("completed_order", func():
		complete_sound.play()
		current_phase += 1
		level += 1
		score += 10
		updateUI()
		updateDifficulty()
		await get_tree().process_frame
		spawner_component.checkTypeNumber()
		spawner_component.ensure_monsters_for_order(order_manager.order_list)
		spawner_component.rerollSpawnAmount(order_manager.order_size)
		life_timer.regainTime(time_regen)
	)
	
	order_manager.connect("mistaken_monster_order", func():
		wrong_sound.play()
		$AnimationPlayer.play("Shake")
		life_timer.loseTime(5)
	)
	#order_manager.connect("completed_order", delivery_area.resetMonsterSlots)
	#order_manager.connect("completed_order", spawner_component.resetSpawner)
	#delivery_area.just_slotted.connect(delivery_area.getMonsterAttributes)
	#delivery_area.just_unslotted.connect(delivery_area.removeMonsterAttributes)
	updateUI()
	pass
	
func updateUI():
	level_label.text = "Level: " + str(level)
	score_label.text = "Score: " + str(score)
	
func updateDifficulty() -> void:
	if current_phase < 5:
		damage_per_second = 1
		order_manager.order_size = 2
		spawner_component.monster_pool_chance[1] = 1

	elif current_phase < 10:
		damage_per_second = 1.5
		spawner_component.monster_pool_chance[0] = 2
		spawner_component.monster_pool_chance[2] = 1
		var rng = randf()
		if rng < 0.6:
			order_manager.order_size = 3
		else:
			order_manager.order_size = 2

	else:
		spawner_component.monster_pool_chance[0] = 2
		spawner_component.monster_pool_chance[1] = 1
		spawner_component.monster_pool_chance[2] = 2
		
		damage_per_second = 2
		var rng = randf()
		if rng < 1 && rng > 0.8:
			order_manager.order_size = 4
		elif rng < 0.8 && rng > 0.5:
			order_manager.order_size = 3
		else:
			order_manager.order_size = 2

func gameOver() -> void:
	ServerData.in_game = false
	Global.score = score
	ServerData.data.totalScore = score
	
	get_tree().change_scene_to_file("res://brain_pack/send_data/data_manager.tscn")
#func getMonsterTypeList() -> void:
