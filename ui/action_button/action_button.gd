extends Area2D

signal action_pressed(type)

@export_enum("Start", "Attack", "Guard", "Magic")
var action_type: String

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("BOTÓN PULSADO")
		action_pressed.emit(action_type)
