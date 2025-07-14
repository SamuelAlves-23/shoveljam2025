extends Node2D

@onready var exit: Area2D = $TriggerArea




func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body is Player:
		print("ENTRANDO EN CAMBIO DE ZONA")


func _on_damage_test_body_entered(body: Node2D) -> void:
	if body is Player:
		PlayerStats.damage(30)
