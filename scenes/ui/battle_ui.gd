class_name BattleUI
extends CanvasLayer

@export var character_stats: CharacterStats : set = set_character_stats

@onready var hand: Hand = $Hand as Hand
@onready var mana_ui: ManaUI = $ManaUI as ManaUI
@onready var end_turn: Button = %EndTurn

func _ready() -> void:
	Events.player_hand_draw.connect(on_player_hand_drawn)
	self.end_turn.pressed.connect(on_end_turn_pressed)

func set_character_stats(value: CharacterStats) -> void:
	character_stats = value
	self.mana_ui.character_stats = value
	self.hand.character_stats = value

func on_end_turn_pressed() -> void:
	self.end_turn.disabled = true
	Events.player_turn_ended.emit()

func on_player_hand_drawn() -> void:
	self.end_turn.disabled = false
