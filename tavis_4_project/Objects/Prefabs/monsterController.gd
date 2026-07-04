class_name MonsterController
extends CharacterBody2D

@export_subgroup("Animation")
@onready var pivot: Node2D = $feet_pivot

@export var squish_amount := 0.1
@export var rotate_amount := 8.0 # degrees
@export var squish_speed := 2

var time := 0.0

@export var animation_resource: AnimationResource

@export_subgroup("Config")
@export var monster_type: monsterType = monsterType.Example_01
@export var action_cooldown: float = 2.0
@export var distance_to_travel: float = 10
@export var speed: float = 1

var walking: bool = false
#var move_direction: Vector2

@onready var action_timer: Timer = $Timer

var delivered := false

enum monsterType{
	Example_01,
	Example_02,
	Example_03
}




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite := $feet_pivot/AnimatedSprite2D

	sprite.material = sprite.material.duplicate()

	var mat := sprite.material as ShaderMaterial

	match monster_type:
		monsterType.Example_01:
			mat.set_shader_parameter("tint_color", Color.RED)

		monsterType.Example_02:
			mat.set_shader_parameter("tint_color", Color.GREEN)

		monsterType.Example_03:
			mat.set_shader_parameter("tint_color", Color.BLUE)
			
	action_timer.wait_time = action_cooldown
	action_timer.connect("timeout", func():
		walkState(action_cooldown, distance_to_travel, speed)
	)
	
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
	#ac

func idleState(delta):
	time += delta

	var t = sin(time * squish_speed)
	var t2 = sin(time * 0.25 * squish_speed)

	pivot.scale.y = 1.0 + t * squish_amount
	pivot.rotation_degrees = t2 * rotate_amount

func walkState(cooldown: float, distance_to_travel: float, speed: float) -> void:
	
	if walking: 
		return
	
	walking = true
	var move_direction: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	var target_location: Vector2 = move_direction * distance_to_travel + global_position
	
	while global_position.distance_to(target_location) > 10:
		global_position = global_position.lerp(target_location, get_process_delta_time() * speed)
	
		await get_tree().process_frame
	
	walking = false
