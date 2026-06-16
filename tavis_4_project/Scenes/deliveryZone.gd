class_name DeliveryZone
extends Node2D

signal just_slotted(monster_added: Node2D)
signal just_unslotted(monster_removed: Node2D)

#@export var coisa: Node2D

var monster_slotted: bool = false
var current_monster: MonsterController

@onready var delivery_zone: CollisionShape2D = $DeliveryZone
@onready var order_manager: OrderManager = $"../OrderManager"
@onready var spawner_component: SpawnerComponent = $"../SpawnerComponent"

var monster_list: Array[MonsterController]
var monster_slot_list: Array[int]

var monster_type_list: Dictionary = {
	"type_1": 0,
	"type_2": 0
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#removeMonsterAtributes()
	#order_manager.connect("completed_order", resetMonsterSlots)
	#order_manager.connect("completed_order", spawner_component.resetSpawner)
	#just_slotted.connect(getMonsterAttributes)
	#just_unslotted.connect(removeMonsterAttributes)
	pass
	

func getMonsterAttributes(monster_added: Node2D) -> void:
	monster_list.append(monster_added)
	
	assignPositions(monster_added)
	
	checkTypeNumber()
	pass

func removeMonsterAttributes(monster_removed: Node2D) -> void: 
	removeMonsterFromSlots(monster_removed)
	
	monster_list.erase(monster_removed)
	
	checkTypeNumber()
	#monster_slotted = false

func resetMonsterSlots() -> void:
	for i in range(1, monster_list.size()):
		monster_list[i] = null
	
	for slot: Slot in delivery_zone.get_children():
		if slot.monster_slotted != null:
			slot.monster_slotted.queue_free()
			slot.monster_slotted = null
	
	checkTypeNumber()

func removeMonsterFromSlots(monster_removed: Node2D) -> void:
	for slot: Slot in delivery_zone.get_children():
		if slot.monster_slotted != null && slot.monster_slotted == monster_removed:
			slot.monster_slotted = null

func assignPositions(monster: Node2D) -> void:
	for slot: Slot in delivery_zone.get_children():
		if slot.monster_slotted == null:
			monster.global_position = slot.global_position
			slot.monster_slotted = monster
			
			return

func checkTypeNumber() -> void:
	var count = 0
	for monster: MonsterController in monster_list:
		if monster != null && monster.monster_type == 0:
			count += 1
			#monster_type_list["type_1"] += 1
	monster_type_list["type_1"] = count
	
	count = 0
	
	for monster: MonsterController in monster_list:
		if monster != null && monster.monster_type == 1:
			count += 1
			#monster_type_list["type_1"] += 1
	monster_type_list["type_2"] = count
