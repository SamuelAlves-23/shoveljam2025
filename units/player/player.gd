extends CharacterBody2D


enum STATES{
	MOVING,
	INTERACTING,
	DEAD
}

@onready var current_state: STATES = STATES.MOVING

## PLAYER STATS
@export var max_hp: int = 100
@export var current_hp: int = 100
@export var attack: int = 10
@export var defense: int = 5
@export var exp_mult: float = 2.0


func _process(delta: float) -> void:
	match current_state:
		STATES.MOVING:
			_move(delta)
		STATES.INTERACTING:
			_interact()
		STATES.DEAD:
			_dead()


func _move(delta) -> void:
	pass

func _interact() -> void:
	pass

func _dead() -> void:
	pass
