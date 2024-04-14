class_name Battle
extends Node2D

@export var character_stats : CharacterStats
@export var music : AudioStream

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler
@onready var player: Player = $Player
@onready var enemy_handler: EnemyHandler = $EnemyHandler

func _ready() -> void:
	var stats : CharacterStats = self.character_stats.create_instance()
	self.battle_ui.set_character_stats(stats)
	self.player.set_character_stats(stats)
	
	Events.enemy_turn_ended.connect(self.on_enemy_turn_ended)
	Events.player_turn_ended.connect(self.player_handler.end_turn)
	Events.player_hand_discarded.connect(self.enemy_handler.start_turn)
	Events.player_died.connect(self.on_player_died)
	
	start_battle(stats)

func start_battle(stats: CharacterStats) -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	self.player_handler.start_battle(stats)
	enemy_handler.reset_enemy_action()

func on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_action()


func _on_enemy_handler_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		Events.battle_over_screen_requested.emit("Victory", BattleOverPanel.TYPE.WIN)

func on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over", BattleOverPanel.TYPE.LOSE)
