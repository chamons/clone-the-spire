class_name Enemy
extends Area2D

const ARROW_OFFSET := 5

const WHITE_SPRITE_MATERIAL = preload("res://art/white_sprite_material.tres")

@export var stats: EnemyStats : set = set_enemy_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var arrow: Sprite2D = $Arrow
@onready var stats_ui: StatsUI = $StatsUI
@onready var intent_ui: IntentUI = $IntentUI

var enemy_action_picker: EnemyActionPicker
var current_action : EnemyAction : set = set_current_action

func set_current_action(value: EnemyAction) -> void:
	current_action = value
	if current_action:
		intent_ui.update_intent(value.intent)

func set_enemy_stats(value: EnemyStats) -> void:
	stats = value.create_instance()
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	if not stats.stats_changed.is_connected(update_action):
		stats.stats_changed.connect(update_action)

	update_enemy()

func setup_ai() -> void:
	if self.enemy_action_picker:
		self.enemy_action_picker.queue_free()
	var new_action_picker: EnemyActionPicker = stats.ai.instantiate()
	add_child(new_action_picker)
	self.enemy_action_picker = new_action_picker
	self.enemy_action_picker.enemy = self

func update_action() -> void:
	if not self.enemy_action_picker:
		return
	if not current_action:
		self.current_action = self.enemy_action_picker.get_action()
		return
	var new_conditional_action := enemy_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		self.current_action = new_conditional_action

func update_stats() -> void:
	self.stats_ui.update_stats(self.stats)
	
func update_enemy() -> void:
	assert (self.stats is Stats)
	if not is_inside_tree():
		await ready
	self.sprite_2d.texture = self.stats.art
	self.arrow.position = Vector2.RIGHT * (self.sprite_2d.get_rect().size.x / 2 + ARROW_OFFSET)
	setup_ai()
	update_stats()
	
func take_damage(damage: int):
	if self.stats.health <= 0:
		return
		
	sprite_2d.material = WHITE_SPRITE_MATERIAL
	
	await Shaker.shake(self, 16, 0.15)
	stats.take_damage(damage)
	await get_tree().create_timer(0.17).timeout
	
	sprite_2d.material = null
	if stats.health <= 0:
		queue_free()

func do_turn() -> void:
	self.stats.block = 0
	if not self.current_action:
		return
	await self.current_action.perform_action()
	intent_ui.clear_intent()

func _on_area_entered(_area: Area2D) -> void:
	self.arrow.show()

func _on_area_exited(_area: Area2D) -> void:
	self.arrow.hide()
