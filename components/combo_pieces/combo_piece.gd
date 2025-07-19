extends Node2D
class_name ComboPiece

@export_enum("attack", "guard", "magic") var piece_name

@onready var modifier: float = 0.1
@onready var sprite: Sprite2D = $Sprite2D

func passive() -> float:
	print("Efecto pasivo")
	return 0.0
