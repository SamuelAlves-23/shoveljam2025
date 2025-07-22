extends Node

signal player_damaged(amount)
signal player_healed(amount)
signal player_dead()

@onready var player_stats: Dictionary = {
	"max_hp" : 100,
	"current_hp": 80,
	"attack": 70,
	"defense": 5,
	"exp_mult": 2.0,
	"parry_chance": 0.1,
	"lifedrain": 0.0
}

@onready var guarding: bool = false
@export var battle_scene: BattleScene

func train_stat(stat: String) -> void:
	var amount: int = 0
	var quality: int = 0
	amount = randi_range(1, 10)
	quality = ceil(amount / 2)
	if stat == "max_hp":
		amount *= 5
		player_stats["current_hp"] += amount
	player_stats[stat] += amount
	player_stats["exp_mult"] -= 0.15

func damage(amount: int)-> void:
	var total_amount: int = amount
	if guarding:
		total_amount -= player_stats["defense"]
		guarding = false
	total_amount -= ceil(battle_scene.check_combo(1))
	player_stats["current_hp"] -= total_amount
	player_damaged.emit(total_amount)
	if player_stats["current_hp"] <= 0:
		player_dead.emit()

func heal(amount) -> void:
	if player_stats["current_hp"] + amount >= player_stats["max_hp"]:
		player_stats["curren_hp"] = player_stats["max_hp"]
	else:
		player_stats["current_hp"] += amount
	player_healed.emit(amount)

func reset_stats() -> void:
	player_stats = {
		"max_hp" : 100,
		"current_hp": 100,
		"attack": 70,
		"defense": 5,
		"exp_mult": 2.0,
		"parry_chance": 0.1,
		"lifedrain": 0.0
	}
