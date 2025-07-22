extends CharacterBody2D
class_name  Enemy

signal enemy_dead(enemy)
signal enemy_damaged(amount)

enum STATES{
	ALIVE,
	DEAD
}

@onready var current_state: STATES = STATES.ALIVE
@onready var guarding: bool = false
@onready var current_combo: Array = []
@onready var battle_scene: BattleScene = get_tree().get_first_node_in_group("BattleScene")

@onready var hp: Control = $EnemyHP
@onready var combo_01_pos: Vector2 = $EnemyHP/Combo01.position
@onready var combo_02_pos: Vector2 = $EnemyHP/Combo02.global_position
@onready var combo_03_pos: Vector2 = $EnemyHP/Combo03.global_position

@onready var enemy_stats: Dictionary = {
	"max_hp" : 100,
	"current_hp": 100,
	"attack": 10,
	"defense": 5
}

@onready var sprite: Sprite2D = $Sprite2D
@onready var life_bar: TextureProgressBar = $EnemyHP/LifeBar
@onready var damage_bar: TextureProgressBar = $EnemyHP/DamageBar
@onready var cursor_pos: Vector2 = $CursorPosition.global_position

func _process(delta: float) -> void:
	match current_state:
		STATES.ALIVE:
			pass
		STATES.DEAD:
			dead()


func dead() -> void:
	sprite.hide()
	enemy_dead.emit(self)
	
func skill() -> void:
	var total_damage: int = enemy_stats["attack"]
	total_damage += ceil(check_combo(0))
	PlayerStats.damage(total_damage)
	add_combo(GlobalManager.combo_pieces[0])

func damage(amount: int) -> void:
	var total_amount: int = amount
	if guarding:
		total_amount -= enemy_stats["defense"]
	enemy_stats["current_hp"] -= total_amount
	if enemy_stats["current_hp"] <= 0:
		current_state = STATES.DEAD
	var lifedrain: float = battle_scene.check_combo(2)
	if lifedrain > 0:
		PlayerStats.heal(total_amount * lifedrain)
	update_life(total_amount)

func update_life(amount: int) -> void:
	for i in range(0, amount, 1):
		life_bar.value -= 1
		if life_bar.value >= 0:
			i = amount
		await get_tree().create_timer(0.001).timeout
	
	await get_tree().create_timer(0.5).timeout
	
	for i in range(0, amount, 1):
		damage_bar.value -= 1
		if damage_bar.value >= 0:
			i = amount
		await get_tree().create_timer(0.01).timeout

func add_combo(piece) -> void:
	var combo_piece = piece.instantiate()
	current_combo.append(combo_piece)
	hp.add_child(combo_piece)
	match current_combo.size:
		1:
			combo_piece.global_postion = combo_01_pos
		2:
			combo_piece.global_postion = combo_02_pos
		3:
			combo_piece.global_postion = combo_02_pos
			finisher()
	

func check_combo(piece_name: int) -> float:
	var result: float
	for combo: ComboPiece in current_combo:
		if combo.piece_name == piece_name:
			result += combo.passive()
	return result

func finisher() -> void:
	for piece in current_combo:
		piece.queue_free()
	current_combo.clear()
