extends Node2D

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

@export var tween_duration: float = 0.1

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	await show_actions()
	await get_tree().create_timer(0.5).timeout
	await hide_actions()

func show_actions() -> void:
	var tween = create_tween()
	start.show()
	tween.tween_property(start, "global_position", start_pos, tween_duration)
	attack.show()
	tween.tween_property(attack, "global_position", attack_pos, tween_duration)
	guard.show()
	tween.tween_property(guard, "global_position", guard_pos, tween_duration)
	magic.show()
	tween.tween_property(magic, "global_position", magic_pos, tween_duration)
	await tween.finished
	start.monitorable = true
	attack.monitorable = true
	guard.monitorable = true
	magic.monitorable = true

func hide_actions() -> void:
	var tween = create_tween()
	tween.tween_property(start, "global_position", remove_pos, tween_duration)
	tween.tween_property(attack, "global_position", remove_pos, tween_duration)
	tween.tween_property(guard, "global_position", remove_pos, tween_duration)
	tween.tween_property(magic, "global_position", remove_pos, tween_duration)
	
	await tween.finished
	start.hide()
	attack.hide()
	magic.hide()
	guard.hide()
	start.monitorable = false
	attack.monitorable = false
	guard.monitorable = false
	magic.monitorable = false
