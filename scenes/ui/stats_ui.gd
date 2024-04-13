class_name StatsUI
extends HBoxContainer


@onready var block_label: Label = %BlockLabel
@onready var block: HBoxContainer = $Block


@onready var health_label: Label = %HealthLabel
@onready var health: HBoxContainer = $Health

func update_stats(stats: Stats) -> void:
	self.block_label.text = str(stats.block)
	self.health_label.text = str(stats.health)

	self.block.visible = stats.block > 0
	self.health.visible = stats.health > 0
