class_name Player
extends Node2D

const WHITE_SPRITE_MATERIAL = preload("res://art/white_sprite_material.tres")

@export var stats: CharacterStats : set = set_character_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI as StatsUI

func set_character_stats(new_stats: CharacterStats) -> void:
	stats = new_stats
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

	sprite_2d.material = WHITE_SPRITE_MATERIAL

	var tween := create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 16, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.17)
	tween.finished.connect(func():
		sprite_2d.material = null

		if stats.health <= 0:
			Events.player_died.emit()
			queue_free()
	)
