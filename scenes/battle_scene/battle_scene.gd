extends Node2D

#signal player_turn()
#signal enemy_turn()

enum STATES{
	PLAYER_TURN,
	TARGETING,
	ENEMY_TURN
}

@onready var current_state: STATES = STATES.PLAYER_TURN
@onready var cursor_rest_pos: Vector2 = $CursorRestPos.global_position
@onready var battle_cursor: Sprite2D = $BattleCursor
@onready var index: int = 0
@onready var first: bool = true
@onready var enemies: Array = [$Enemy, $Enemy2, $Enemy3]
@onready var player: Player = $Player
@onready var actions_holder: ActionsHolder = $ActionsHolder
@onready var combo_container: HBoxContainer = $ComboContainer

@onready var combo_options: Array = ["attack", "guard", "magic"]
@onready var current_combo: Array = []

@onready var is_player_turn: bool = true

func _ready() -> void:
	battle_cursor.global_position = cursor_rest_pos
	for enemy in enemies:
		enemy.connect("enemy_dead", erase_enemy)

func _process(delta) -> void:
	match current_state:
		STATES.PLAYER_TURN:
			if first:
				first = false
				PlayerStats.guarding = false
				#actions_holder.show_actions()
		STATES.TARGETING:
			target_selection()
		STATES.ENEMY_TURN:
			enemy_turn()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		#actions_holder.hide_actions()
		update_state(STATES.TARGETING)
	elif event.is_action_pressed("guard"):
		print("BLOQUEANDO")
		#actions_holder.hide_actions()
		PlayerStats.guarding = true
		add_combo(GlobalManager.combo_pieces[1])
		update_state(STATES.ENEMY_TURN)
	elif event.is_action_pressed("magic"):
		print("Magia")
		#actions_holder.hide_actions()
		for enemy in enemies:
			enemy.damage(ceil(PlayerStats.player_stats["attack"]/ 2))
		add_combo(GlobalManager.combo_pieces[2])
		update_state(STATES.ENEMY_TURN)
	else:
		print("EMPIEZA EL COMBO")
		#actions_holder.hide_actions()
		add_combo(GlobalManager.combo_pieces.pick_random())
		print(current_combo)
		update_state(STATES.ENEMY_TURN)

func erase_enemy(enemy) -> void:
	enemies.erase(enemy)

func add_combo(piece) -> void:
	var combo_piece = piece.instantiate()
	current_combo.append(combo_piece)
	combo_container.add_child(combo_piece)
	#combo_piece.global_position = combo_container.global_position

func combo_finisher() -> void:
	print("COMBO FINISHER")
	current_combo = []

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
	elif Input.is_action_just_pressed("confirm"):
		battle_cursor.global_position = cursor_rest_pos
		player_attack()
		first = true

func player_attack() -> void:
	enemies[index].damage(PlayerStats.player_stats["attack"])
	add_combo(GlobalManager.combo_pieces[0])
	update_state(STATES.ENEMY_TURN)

func update_state(new_state: STATES) -> void:
	current_state = new_state
	#first = true

func enemy_turn() -> void:
	for enemy in enemies:
		enemy.skill()
	update_state(STATES.PLAYER_TURN)
