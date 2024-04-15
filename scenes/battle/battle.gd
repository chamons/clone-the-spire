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
	self.player_handler.character_stats = stats
	
	Events.player_died.connect(self.on_player_died)
	
	run_battle()

func run_battle() -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	player_handler.start_battle()
	
	while true:
		enemy_handler.update_enemy_actions()
		await player_handler.start_turn()
		battle_ui.allow_play()
		
		await battle_ui.end_turn()
		await player_handler.end_turn()
		
		await enemy_handler.start_turn()

func _on_enemy_handler_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		Events.battle_over_screen_requested.emit("Victory", BattleOverPanel.TYPE.WIN)

func on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over", BattleOverPanel.TYPE.LOSE)
