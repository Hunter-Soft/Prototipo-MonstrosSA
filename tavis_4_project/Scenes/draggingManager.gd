class_name DraggingManager
extends Node2D

const MONSTER_COLLISION_MASK = 2
const MONSTER_SLOT_COLLISION_MASK = 4

var screen_size: Vector2
var current_monster: Node2D
var monster_being_dragged

var hovering_monster: bool = false
var holding_monster: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#monster_being_dragged.dragging = holding_monster
	if monster_being_dragged:
		holding_monster = true
	else:
		holding_monster = false
	
	if holding_monster:
		var mouse_position = get_global_mouse_position()
		current_monster.position = Vector2(clamp(mouse_position.x, 0, screen_size.x), clamp(mouse_position.y, 0, screen_size.y))
		
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			current_monster = raycastCardCheck()
			if current_monster:
				startDrag(current_monster)
			#print("current_monster.name")
		else:
			if current_monster:
				endDrag()
			#holding_monster = false

func startDrag(monster: Node2D) -> void:
	monster_being_dragged = monster
	#monster.state_component.current_drag = 0
	monster.scale = Vector2(1, 1)
	
	monster_being_dragged.slotted = false
	
	var monster_slot_found = raycastCardSlotCheck() as DeliveryZone
	
	if monster_slot_found && monster_slot_found.monster_slotted && monster_being_dragged == monster_slot_found.current_monster:
		monster_slot_found.emit_signal("just_unslotted")
		monster_slot_found.current_monster = null
		
	#print(monster_slot_found)

func endDrag() -> void:
	#monster_being_dragged.state_component.current_drag = 1
	#monster_being_dragged.scale = Vector2(1.05, 1.05)
	var monster_slot_found: DeliveryZone = raycastCardSlotCheck()
	if monster_slot_found && !monster_slot_found.monster_slotted:
		monster_being_dragged.global_position = monster_slot_found.global_position
		monster_being_dragged.slotted = true
		#monster_slot_found.get_node("Area2D/CollisionShape2D").disabled = true
		monster_slot_found.current_monster = monster_being_dragged
		monster_slot_found.emit_signal("just_slotted")
	#elif monster_slot_found && 
	monster_being_dragged = null



func connectMonsterSignals(monster: MonsterController) -> void:
	#monster.state_component.connect("hovered", onHoverOverCardOn)
	#monster.state_component.connect("hovered_off", onHoverOverCardOff)
	pass

func onHoverOverCardOff(monster) -> void:
		highlightCard(monster, false)

func onHoverOverCardOn(monster) -> void:
		highlightCard(monster, true)
	
func highlightCard(monster: Node2D, hovered: bool):
	if hovered:
		monster.scale = Vector2(1.05, 1.05)
		monster.z_index = 2
	else:
		monster.scale = Vector2(1, 1)
		monster.z_index = 1
	
func raycastCardSlotCheck():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = MONSTER_SLOT_COLLISION_MASK
	
	var result = space_state.intersect_point(parameters)
	
	if result.size() > 0:
		return result[0].collider
		#return result[0].collider.get_parent() VOLTAR DEPOIS NICOLLAS
	return null

func raycastCardCheck():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = MONSTER_COLLISION_MASK
	
	var result = space_state.intersect_point(parameters)
	
	if result.size() > 0:
		return result[0].collider.get_parent()
		#return result[0].collider.get_parent() VOLTAR DEPOIS NICOLLAS
	return null
	
