class_name Battle
extends Node2D

@export var character_stats : CharacterStats

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var player: Player = $Player

func _ready() -> void:
	var stats : CharacterStats = self.character_stats.create_instance()
	self.battle_ui.set_character_stats(stats)
	self.player.set_character_stats(stats)
	
	Events.player_turn_ended.connect(self.player_handler.end_turn)
	Events.player_hand_discarded.connect(self.player_handler.start_turn)
	
	start_battle(stats)

func start_battle(stats: CharacterStats) -> void:
	self.player_handler.start_battle(stats)
