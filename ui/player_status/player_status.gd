extends Control

@onready var life_bar: TextureProgressBar = $LifeBar
@onready var damage_bar: TextureProgressBar = $DamageBar

func _ready() -> void:
	PlayerStats.connect("player_damaged", update_life)

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
