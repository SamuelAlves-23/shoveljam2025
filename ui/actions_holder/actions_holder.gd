extends Node2D
class_name ActionsHolder

@onready var remove_pos: Vector2 = $RemovePos.global_position
@onready var attack_pos: Vector2 = $AttackPos.global_position
@onready var guard_pos: Vector2 = $GuardPos.global_position
@onready var start_pos: Vector2 = $StartPos.global_position
@onready var magic_pos: Vector2 = $MagicPos.global_position
@onready var limit_pos: Vector2 = $LimitPos.global_position

@onready var start: Area2D = $Start
@onready var attack: Area2D = $Attack
@onready var guard: Area2D = $Guard
@onready var magic: Area2D = $Magic

@export var tween_duration: float = 0.2

func _ready() -> void:
	show_actions()

func show_actions() -> void:
	start.show()
	attack.show()
	guard.show()
	magic.show()

	await get_tree().process_frame  # Asegura actualización de layout antes de tweens si es necesario

	var tween = create_tween()
	tween.tween_property(start, "global_position", start_pos, tween_duration)
	tween.tween_property(attack, "global_position", attack_pos, tween_duration)
	tween.tween_property(guard, "global_position", guard_pos, tween_duration)
	tween.tween_property(magic, "global_position", magic_pos, tween_duration)
	await tween.finished

	# No es necesario alterar monitorable aquí para Control/Button
	# Si usas Area2D y lo necesitas:
	# for b in [start, attack, guard, magic]:
	#     b.monitorable = true

func hide_actions() -> void:
	var tween = create_tween()
	tween.tween_property(start, "global_position", remove_pos, tween_duration)
	tween.tween_property(attack, "global_position", remove_pos, tween_duration)
	tween.tween_property(guard, "global_position", remove_pos, tween_duration)
	tween.tween_property(magic, "global_position", remove_pos, tween_duration)
	await tween.finished

	start.hide()
	attack.hide()
	guard.hide()
	magic.hide()

	# No es necesario alterar monitorable aquí para Control/Button
	# Si usas Area2D y lo necesitas:
	# for b in [start, attack, guard, magic]:
	#     b.monitorable = false
