class_name MonsterController
extends CharacterBody2D

signal delivered

@export_subgroup("Animation")
@onready var pivot: Node2D = $feet_pivot
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var tp_particle: PackedScene = load("res://Objects/Prefabs/TP_start.tscn")

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
@export var offset_amount: float = 0.1

var walking: bool = false
#var move_direction: Vector2

@onready var action_timer: Timer = $Timer

var monster_color: Color = Color.WHITE

enum monsterType{
	Example_01,
	Example_02,
	Example_03,
	Urgent
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delivered.connect(func() -> void:
		$CPUParticles2D.emitting = true
	)
	randomizeStats()
	
	var sprite := $feet_pivot/AnimatedSprite2D

	sprite.material = sprite.material.duplicate()

	var mat := sprite.material as ShaderMaterial

	match monster_type:
		monsterType.Example_01:
			mat.set_shader_parameter("tint_color", Color.YELLOW)

		monsterType.Example_02:
			mat.set_shader_parameter("tint_color", Color.GREEN)

		monsterType.Example_03:
			mat.set_shader_parameter("tint_color", Color.BLUE)
		
		monsterType.Urgent:
			mat.set_shader_parameter("tint_color", Color.RED)
			
	action_timer.wait_time = action_cooldown
	action_timer.connect("timeout", func():
		if monster_type == monsterType.Example_01:
			walkState(action_cooldown, distance_to_travel, speed) #Andar Nomarl
		elif monster_type == monsterType.Example_02:
			anim_player.play("Blink")
			
			var new_particle: CPUParticles2D = tp_particle.instantiate()
			new_particle.global_position = global_position
			get_tree().root.add_child(new_particle)
			
			
			await get_tree().create_timer(0.3).timeout
			walkState(action_cooldown, distance_to_travel * 1.5, speed*30) #Teleporte
			await get_tree().create_timer(0.1).timeout
			$CPUParticles2D.emitting = true
			#NICOLLAS LEMBRAR
			
		elif monster_type == monsterType.Example_03:
			walkState(action_cooldown, distance_to_travel*2, speed*3) #Dash
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
	if !ServerData.in_game:
		action_timer.stop()
	
	idleState(delta)
	
	#ac

func randomizeStats() -> void:
	action_cooldown += randf_range(-offset_amount, offset_amount)

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
	
	var target_direction: Vector2 = global_position.direction_to(target_location)
	
	while global_position.distance_to(target_location) > 10:
		var distance_remaining = global_position.distance_to(target_location)
		#var current_speed = target_location / distance_remaining
		
		
		#var collision = move_and_collide(target_direction * speed)
		#var collision = move_and_collide(target_direction * min(speed, distance_remaining * speed))
		var collision = move_and_collide(target_direction * distance_remaining * 2 * speed * get_process_delta_time())
		
		if collision:
			walking = false
			velocity = Vector2.ZERO
			
			break
		
		#velocity = target_direction * speed * 100
		#move_and_slide()
		#global_position = global_position.lerp(target_location, get_process_delta_time() * speed)
		#move_and_collide(target_direction * speed)
		await get_tree().process_frame
	
	walking = false
