extends Node2D
class_name BattleScene

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
@onready var changing_state: bool = false
@onready var enemies: Array = [$Enemy, $Enemy2, $Enemy3]
@onready var player: Player = $Player
@onready var actions_holder: ActionsHolder = $ActionsHolder
@onready var combo_container: HBoxContainer = $CanvasLayer/Control/ComboContainer
@onready var impulse_combo_pos: Vector2 = $CanvasLayer/Control/ComboContainer/ImpulsePos.global_position
@onready var combo_01_pos: Vector2 = $CanvasLayer/Control/ComboContainer/Combo01Pos.global_position
@onready var combo_02_pos: Vector2 = $CanvasLayer/Control/ComboContainer/Combo02Pos.global_position
@onready var combo_03_pos: Vector2 = $CanvasLayer/Control/ComboContainer/Combo03Pos.global_position


@onready var combo_options: Array = ["attack", "guard", "magic"]
@onready var allowed_actions: Array = ["attack", "guard", "magic"]
@onready var current_combo: Array = []



@onready var is_player_turn: bool = true

func _ready() -> void:
	PlayerStats.battle_scene = self
	battle_cursor.global_position = cursor_rest_pos
	for enemy in enemies:
		enemy.connect("enemy_dead", erase_enemy)

func _process(delta) -> void:
	match current_state:
		STATES.PLAYER_TURN:
			player_turn()
		STATES.TARGETING:
			target_selection()
		STATES.ENEMY_TURN:
			enemy_turn()


func _unhandled_input(event: InputEvent) -> void:
	if action_allowed(event):
		if current_combo.size() != 0:
			if event.is_action_pressed("attack"):
				await actions_holder.hide_actions()
				update_state(STATES.TARGETING)
			elif event.is_action_pressed("guard"):
				print("BLOQUEANDO")
				await actions_holder.hide_actions()
				PlayerStats.guarding = true
				add_combo(GlobalManager.combo_pieces[1])
				print(current_combo)
				update_state(STATES.ENEMY_TURN)
			elif event.is_action_pressed("magic"):
				print("Magia")
				await actions_holder.hide_actions()
				for enemy in enemies:
					enemy.damage(ceil(PlayerStats.player_stats["attack"] / 2))
				add_combo(GlobalManager.combo_pieces[2])
				print(current_combo)
				update_state(STATES.ENEMY_TURN)
		else:
			print("EMPIEZA EL COMBO")
			await actions_holder.hide_actions()
			add_combo(GlobalManager.combo_pieces.pick_random())
			print(current_combo)
			update_state(STATES.ENEMY_TURN)

func action_allowed(event: InputEvent) -> bool:
	for action in allowed_actions:
		if event.is_action_pressed(action):
			return true
	return false

func erase_enemy(enemy) -> void:
	enemies.erase(enemy)

func add_combo(piece) -> void:
	var combo_piece = piece.instantiate()
	current_combo.append(combo_piece)
	combo_container.add_child(combo_piece)
	match current_combo.size():
		1:
			combo_piece.global_position = impulse_combo_pos
		2:
			combo_piece.global_position = combo_01_pos
		3:
			combo_piece.global_position = combo_02_pos
		4:
			combo_piece.global_position = combo_03_pos
			combo_finisher()
			

func combo_finisher() -> void:
	print("COMBO FINISHER")
	for combo in current_combo:
		combo.queue_free()
	current_combo.clear()

func player_turn() -> void:
	if first:
		first = false
		PlayerStats.guarding = false
		actions_holder.show_actions()

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
	var damage: int = PlayerStats.player_stats["attack"]
	damage += ceil(check_combo(0))
	enemies[index].damage(damage)
	add_combo(GlobalManager.combo_pieces[0])
	print(current_combo)
	update_state(STATES.ENEMY_TURN)

func update_state(new_state: STATES) -> void:
	current_state = new_state
	first = true

func check_combo(piece_name: int) -> float:
	var result: float
	for combo: ComboPiece in current_combo:
		if combo.piece_name == piece_name:
			result += combo.passive()
	return result

func enemy_turn() -> void:
	for enemy in enemies:
		enemy.skill()
	update_state(STATES.PLAYER_TURN)
