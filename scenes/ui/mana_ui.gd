class_name ManaUI
extends Panel

@export var character_stats: CharacterStats : set = set_character_stats

@onready var mana_label: Label = $ManaLabel

func set_character_stats(value: CharacterStats) -> void:
	character_stats = value
	if not character_stats.stats_changed.is_connected(on_stats_changed):
		character_stats.stats_changed.connect(on_stats_changed)

	if not self.is_node_ready():
		await self.ready

	on_stats_changed()

func on_stats_changed() -> void:
	self.mana_label.text = "%s/%s" % [self.character_stats.mana, self.character_stats.max_mana]
