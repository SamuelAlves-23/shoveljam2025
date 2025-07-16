extends Control

signal attack_pressed()

@onready var atk_btn: TextureButton = $ActionsPanel/VBoxContainer/AttackButton
@onready var skill_btn: TextureButton = $ActionsPanel/VBoxContainer/SkillButton
@onready var limit_btn: TextureButton = $ActionsPanel/VBoxContainer/LimitButton

@onready var skills_panel: Panel = $SkillsPanel

func _on_attack_button_pressed() -> void:
	if !atk_btn.disabled:
		print("ATACANDO")
		attack_pressed.emit()

func enable_btns() -> void:
	atk_btn.disabled = false
	skill_btn.disabled = false
	limit_btn.disabled = false

func disable_btns() -> void:
	atk_btn.disabled = true
	skill_btn.disabled = true
	limit_btn.disabled = true


func _on_skill_button_pressed() -> void:
	pass
