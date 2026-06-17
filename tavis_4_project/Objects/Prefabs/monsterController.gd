class_name MonsterController
extends CharacterBody2D

@export_subgroup("Config")
@export_enum("Example_01", "Example_02", "Example_03") var monster_type = "Example_01"

@export_subgroup("States")
@export var slotted: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
