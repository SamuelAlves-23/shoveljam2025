extends Area2D

signal action_pressed(type)

@export_enum("Start", "Attack", "Guard", "Magic")
var action_type: String

func _on_pressed() -> void:
	action_pressed.emit(action_type)
