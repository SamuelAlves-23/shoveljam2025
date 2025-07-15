extends Node

signal player_damaged(current_hp)

@onready var player_stats: Dictionary = {
	"max_hp" : 100,
	"current_hp": 100,
	"attack": 10,
	"defense": 5,
	"exp_mult": 2.0
}

@onready var skills: Array = []

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
	var total_amount: int = amount - player_stats["defense"]
	player_stats["current_hp"] -= total_amount
	player_damaged.emit(total_amount)

func reset_stats() -> void:
	player_stats = {
		"max_hp" : 100,
		"current_hp": 100,
		"attack": 10,
		"defense": 5,
		"exp_mult": 2.0
	}
