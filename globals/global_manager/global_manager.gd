extends Node

@onready var grid_size: int = 32


func go_to_scene(new_scene: String) -> void:
	get_tree().change_scene_to_file(new_scene)
