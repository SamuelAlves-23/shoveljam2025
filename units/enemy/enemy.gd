extends CharacterBody2D
class_name  Enemy


@onready var enemy_stats: Dictionary = {
	"max_hp" : 100,
	"current_hp": 100,
	"attack": 10,
	"defense": 5
}

@onready var life_bar: TextureProgressBar = $EnemyHP/LifeBar
@onready var damage_bar: TextureProgressBar = $EnemyHP/DamageBar
@onready var cursor_pos: Vector2 = $CursorPosition.global_position

func skill() -> void:
	print("Una skill")


func damage(amount: int) -> void:
	var total_amount: int = amount - enemy_stats["defense"]
	enemy_stats["current_hp"] -= total_amount
	update_life(total_amount)

func update_life(amount: int) -> void:
	for i in range(0, amount, 1):
		life_bar.value -= 1
		await get_tree().create_timer(0.001).timeout
	
	await get_tree().create_timer(0.5).timeout
	
	for i in range(0, amount, 1):
		damage_bar.value -= 1
		await get_tree().create_timer(0.01).timeout
