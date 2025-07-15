extends Node2D

signal player_turn()
signal enemy_turn()

enum STATES{
	PLAYER_TURN,
	TARGETING,
	ENEMY_TURN
}

@onready var current_state: STATES = STATES.PLAYER_TURN

@onready var battle_ui: Control = $CanvasLayer/BattleUI
@onready var battle_cursor: Sprite2D = $BattleCursor
@onready var index: int = 0
@onready var first: bool = true
@onready var enemies: Array = [$Enemy, $Enemy2, $Enemy3]
@export var player = PlayerStats #???

@onready var is_player_turn: bool = true

func _ready() -> void:
	battle_ui.connect("attack_pressed", atk_btn_pressed)

func _process(delta) -> void:
	match current_state:
		STATES.PLAYER_TURN:
			pass
		STATES.TARGETING:
			target_selection()
		STATES.ENEMY_TURN:
			pass

func atk_btn_pressed() -> void:
	current_state = STATES.TARGETING

func target_selection() -> void:
	if first:
		index = 0
		battle_cursor.global_position = enemies[index].cursor_pos
		first = false
	
	if Input.is_action_just_pressed("move_up"):
		index -= 1
		if index < 0:
			index = enemies.size() - 1
		battle_cursor.global_position = enemies[index].cursor_pos
	elif Input.is_action_just_pressed("move_down"):
		index += 1
		if index >= enemies.size():
			index = 0
		battle_cursor.global_position = enemies[index].cursor_pos


func player_attack() -> void:
	pass
