class_name MonsterController
extends CharacterBody2D

@export var y_squish: Vector2
@export var rotation_factor: Vector2
var growing: bool

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
	print(scale.y)
	scale.y = float(y_squish.x)
	print(scale.y)
	#animation_resource = animation_resource.duplicate()
	#animation_resource.master = self
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#walkState(1, 10, 1)
	#animation_resource.animateIdle()
	if scale.y <= y_squish.y:
		growing = true
		#scale.y = lerp(scale.y, y_squish.x, 1 * delta)
		#print("Aumentando")
		#print(scale.y)
	elif scale.y >= y_squish.x:
		growing = false
		#scale.y = lerp(scale.y, y_squish.y, 1 * delta)
		#print("Diminuindo")
		#print(scale.y)
	if growing: 
		scale.y = lerp(scale.y, y_squish.x, 1 * delta)
		#print("Aumentando")
		#print(scale.y)
	else:
		scale.y = lerp(scale.y, y_squish.y, 1 * delta)
		#print("Diminuindo")
		#print(scale.y)
	pass

#func walkState(cooldown: float, distance_to_travel: float, speed: float) -> void:
	#await $CooldownTimer.timeout
	#
	#print("MOVENDO")
	#
	#pass
