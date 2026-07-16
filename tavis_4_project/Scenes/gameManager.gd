class_name GameManager
extends Node2D

signal monster_data_ready

@onready var click_sound: AudioStreamPlayer = $ClickSound
@onready var complete_sound: AudioStreamPlayer = $CompleteSound
@onready var wrong_sound: AudioStreamPlayer = $WrongSound

#@onready var delivery_area: DeliveryZone = $DeliveryArea
#@onready var delivery_zone: CollisionShape2D = $DeliveryArea/DeliveryZone
@onready var life_timer: LifeTimer = $CanvasLayer
@onready var order_manager: OrderManager = $OrderManager
@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@export var monster_type_list: Dictionary

@export var time_regen: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ServerData.in_game = true
	
	spawner_component.connect("monster_type_list_changed", func(type_list):
		monster_type_list = type_list

		print("Monstros disponíveis:", monster_type_list)

		monster_data_ready.emit()
	)
	
	order_manager.connect("completed_order", func():
		complete_sound.play()
		await get_tree().process_frame
		spawner_component.checkTypeNumber()
		spawner_component.ensure_monsters_for_next_order()
		spawner_component.rerollSpawnAmount(order_manager.order_size)
		life_timer.regainTime(time_regen)
	)
	
	order_manager.connect("mistaken_monster_order", func():
		wrong_sound.play()
		life_timer.loseTime(5)
	)
	#order_manager.connect("completed_order", delivery_area.resetMonsterSlots)
	#order_manager.connect("completed_order", spawner_component.resetSpawner)
	#delivery_area.just_slotted.connect(delivery_area.getMonsterAttributes)
	#delivery_area.just_unslotted.connect(delivery_area.removeMonsterAttributes)
	pass

#func getMonsterTypeList() -> void:
