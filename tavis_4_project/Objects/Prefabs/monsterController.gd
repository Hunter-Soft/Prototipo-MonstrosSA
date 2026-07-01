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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#walkState(1, 10, 1)
	pass

#func walkState(cooldown: float, distance_to_travel: float, speed: float) -> void:
	#await $CooldownTimer.timeout
	#
	#print("MOVENDO")
	#
	#pass
