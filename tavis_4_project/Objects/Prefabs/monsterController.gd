class_name MonsterController
extends CharacterBody2D

@export_subgroup("Animation")
@onready var pivot: Node2D = $feet_pivot

@export var squish_amount := 0.1
@export var rotate_amount := 8.0 # degrees
@export var squish_speed := 2

var time := 0.0


@export var animation_resource: AnimationResource

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
	#print(scale.y)
	#scale.y = float(y_squish.x)
	#print(scale.y)
	#animation_resource = animation_resource.duplicate()
	#animation_resource.master = self
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#@export var squish_amount: = 0.1
#@export var rotate_amount: = 0.1
#@export var squish_speed: = 2.0
#var time: = 0.0

func _process(delta: float) -> void:
	idleState(delta)

func idleState(delta):
	time += delta

	var t = sin(time * squish_speed)
	var t2 = sin(time * 0.25 * squish_speed)

	pivot.scale.y = 1.0 + t * squish_amount
	pivot.rotation_degrees = t2 * rotate_amount

#func walkState(cooldown: float, distance_to_travel: float, speed: float) -> void:
	#await $CooldownTimer.timeout
	#
	#print("MOVENDO")
	#
	#pass
