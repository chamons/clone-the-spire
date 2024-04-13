class_name Player
extends Node2D

@export var stats: CharacterStats : set = set_character_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI as StatsUI

func set_character_stats(value: CharacterStats) -> void:
	stats = value.create_instance()
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	update_player()
	
func update_player() -> void:
	if not self.stats is CharacterStats: # Change to assert
		return
	if not is_inside_tree():
		await ready
	self.sprite_2d.texture = self.stats.art
	update_stats()

func update_stats():
	self.stats_ui.update_stats(self.stats)

func take_damage(damage: int) -> void:
	if self.stats.health <= 0:
		return
	self.stats.take_damage(damage)
	if self.stats.health <= 0:
		self.queue_free()
