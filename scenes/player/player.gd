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
	assert (self.stats is CharacterStats)
	if not is_inside_tree():
		await ready
	self.sprite_2d.texture = self.stats.art
	update_stats()

func update_stats():
	self.stats_ui.update_stats(self.stats)

func take_damage(damage: int):
	if self.stats.health <= 0:
		return

	sprite_2d.material = WHITE_SPRITE_MATERIAL

	await Shaker.shake(self, 16, 0.15)
	await stats.take_damage(damage)
	await get_tree().create_timer(0.17).timeout
	
	sprite_2d.material = null
	if stats.health <= 0:
		Events.player_died.emit()
		queue_free()
