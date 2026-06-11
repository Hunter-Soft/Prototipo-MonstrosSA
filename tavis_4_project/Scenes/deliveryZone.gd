class_name DeliveryZone
extends Node2D

signal just_slotted
signal just_unslotted

#@export var coisa: Node2D

var monster_slotted: bool = false
var current_monster: MonsterController

#@export_subgroup("Characteristics")
#@export var consuming_volts: float = 0
#@export var generating_volts: float = 0
#@export var current_volts: float = 0
#@export var current_resistance: float = 0
#@export var transmitting: bool = false
#@export var working: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resetAtributes()
	just_slotted.connect(getCardAtributes)
	#just_slotted.connect($CPUParticles2D.pla)
	just_unslotted.connect(resetAtributes)
	pass # Replace with function body.

func getCardAtributes() -> void:
	#$CPUParticles2D.emitting = true
	#print(current_volts)
	#generating_volts = current_monster.generating_volts
	#consuming_volts = current_monster.consuming_volts
	#current_volts = current_monster.current_volts
	#current_resistance = current_monster.current_resistance
	#transmitting = current_monster.transmitting
	#print(current_volts)
	#if generating_volts == 0:
	#checkStates()
	pass
	
func checkStates() -> void:
	#print(current_volts)
	#if current_volts > consuming_volts:
		#current_monster.state_component.current_state = current_monster.state_component.STATES.BURNT
		##print("Queimado")
	#elif current_volts < consuming_volts:
		#current_monster.state_component.current_state = current_monster.state_component.STATES.OFF
		##print("Desligado")
	#else:
		#current_monster.state_component.current_state = current_monster.state_component.STATES.ON
		##print("Ligado")
	#print("Corrente: %d | Consumindo: %d | Estado: %d" % [current_volts, consuming_volts, current_monster.state_component.current_state])
	pass
#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_monster:
		monster_slotted = true
		checkStates() #Otimizar para funcionar apenas durante o slotted e o unslotted

func resetAtributes() -> void: 
	if current_monster != null:
		current_monster.state_component.current_state = current_monster.state_component.STATES.OFF
	
	monster_slotted = false
