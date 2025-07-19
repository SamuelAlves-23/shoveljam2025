extends Node

@onready var grid_size: int = 32
@onready var combo_pieces: Array = [preload("res://components/combo_pieces/combo_attack/combo_attack.tscn"), preload("res://components/combo_pieces/combo_guard/combo_guard.tscn"), preload("res://components/combo_pieces/combo_magic/combo_magic.tscn")]


func go_to_scene(new_scene: String) -> void:
	get_tree().change_scene_to_file(new_scene)
