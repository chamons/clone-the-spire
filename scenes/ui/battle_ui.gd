class_name BattleUI
extends CanvasLayer

@export var character_stats: CharacterStats : set = set_character_stats

@onready var hand: Hand = $Hand as Hand
@onready var mana_ui: ManaUI = $ManaUI as ManaUI
@onready var end_turn_button: Button = %EndTurn

func set_character_stats(value: CharacterStats) -> void:
	character_stats = value
	self.mana_ui.character_stats = value
	self.hand.character_stats = value

func allow_play() -> void:
	self.end_turn_button.disabled = false

func end_turn() -> void:
	await end_turn_button.pressed
	self.end_turn_button.disabled = true
