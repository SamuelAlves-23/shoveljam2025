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
@onready var battle_scene: BattleScene = get_tree().get_first_node_in_group("BattleScene")

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
	print("Una skill")


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
	
