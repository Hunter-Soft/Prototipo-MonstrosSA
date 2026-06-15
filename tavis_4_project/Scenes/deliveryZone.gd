class_name DeliveryZone
extends Node2D

signal just_slotted(monster_added: Node2D)
signal just_unslotted(monster_removed: Node2D)

#@export var coisa: Node2D

var monster_slotted: bool = false
var current_monster: MonsterController

var monster_list: Array[MonsterController]

#@export_subgroup("Characteristics")
#@export var consuming_volts: float = 0
#@export var generating_volts: float = 0
#@export var current_volts: float = 0
#@export var current_resistance: float = 0
#@export var transmitting: bool = false
#@export var working: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#removeMonsterAtributes()
	just_slotted.connect(getMonsterAttributes)
	just_unslotted.connect(removeMonsterAttributes)

func getMonsterAttributes(monster_added: Node2D) -> void:
	monster_list.append(monster_added)
	pass

func removeMonsterAttributes(monster_removed: Node2D) -> void: 
	monster_list.erase(monster_removed)
	#monster_slotted = false

func checkStates() -> void:
	pass
#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if current_monster:
		#monster_slotted = true
	pass
