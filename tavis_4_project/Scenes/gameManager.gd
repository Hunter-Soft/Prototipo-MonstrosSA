class_name GameManager
extends Node2D

signal monster_data_ready

#@onready var delivery_area: DeliveryZone = $DeliveryArea
@onready var delivery_zone: CollisionShape2D = $DeliveryArea/DeliveryZone
#@onready var order_manager: OrderManager = $OrderManager
@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@export var monster_type_list: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawner_component.connect("monster_type_list_changed", func(type_list):
		monster_type_list = type_list

		print("Monstros disponíveis:", monster_type_list)

		monster_data_ready.emit()
	)
	#order_manager.connect("completed_order", delivery_area.resetMonsterSlots)
	#order_manager.connect("completed_order", spawner_component.resetSpawner)
	#delivery_area.just_slotted.connect(delivery_area.getMonsterAttributes)
	#delivery_area.just_unslotted.connect(delivery_area.removeMonsterAttributes)
	pass

#func getMonsterTypeList() -> void:
