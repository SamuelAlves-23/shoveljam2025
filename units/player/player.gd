extends CharacterBody2D
class_name Player

@onready var sprite: Sprite2D = $Sprite2D
@onready var ray_cast: RayCast2D = $RayCast2D


enum STATES{
	MOVING,
	INTERACTING,
	FIGHTING,
	DEAD
}

@export var current_state: STATES = STATES.MOVING


func _process(delta: float) -> void:
	match current_state:
		STATES.MOVING:
			_move(delta)
		STATES.INTERACTING:
			_interact()
		STATES.FIGHTING:
			_fight()
		STATES.DEAD:
			_dead()


func _move(delta) -> void:
	if Input.is_action_just_pressed("move_up"):
		if await _update_raycast(Vector2(0,-32)):
			global_position.y -= 32
	elif Input.is_action_just_pressed("move_down"):
		if await _update_raycast(Vector2(0, 32)):
			global_position.y += 32
	elif Input.is_action_just_pressed("move_left"):
		if await _update_raycast(Vector2(-32,0)):
			global_position.x -= 32
		sprite.flip_h = false
	elif Input.is_action_just_pressed("move_right"):
		if await _update_raycast(Vector2(32,0)):
			global_position.x += 32
		sprite.flip_h = true

func _interact() -> void:
	pass

func _fight() -> void:
	pass

func _dead() -> void:
	pass


func _update_raycast(dir: Vector2) -> bool:
	var result: bool = false
	ray_cast.target_position = dir
	#interactive_area.position = dir
	await get_tree().create_timer(0.01).timeout
	if !ray_cast.is_colliding():
		result = true
	return result
