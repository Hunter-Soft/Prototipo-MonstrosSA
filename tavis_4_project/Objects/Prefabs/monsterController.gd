class_name MonsterController
extends CharacterBody2D

var delivered := false
enum monsterType{
	Example_01,
	Example_02,
	Example_03
}

@export_subgroup("Config")
@export var monster_type: monsterType = monsterType.Example_01

@onready var collider: Area2D = $Area2D

@export_subgroup("States")
@export var slotted: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#collider.area_entered
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
