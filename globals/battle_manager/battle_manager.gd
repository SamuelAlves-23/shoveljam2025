extends Node

signal player_turn()
signal enemy_turn()


@export var player = PlayerStats #???
@export var enemies: Array = []

@onready var is_player_turn: bool = true


func manage_turn() -> void:
	pass




func player_attack() -> void:
	pass
