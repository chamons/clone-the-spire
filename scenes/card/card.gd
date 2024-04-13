class_name Card
extends Control

signal reparent_requested(card: Card)

const BASE_STYLEBOX := preload("res://scenes/card/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scenes/card/card_dragging_style_box.tres")
const HOVER_STYLEBOX := preload("res://scenes/card/card_hover_stylebox.tres")

@export var card: CardResource : set = set_card
@export var character_stats: CharacterStats : set = set_character_stats

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon

@onready var drop_point_detector: Area2D = $DropDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets : Array[Node] = []
@onready var original_index := self.get_index()

var parent: Control
var tween: Tween
var playable := true : set = set_playable
var disabled := false

func _ready() -> void:
	Events.card_aim_started.connect(on_card_drag_or_aim_started)
	Events.card_drag_started.connect(on_card_drag_or_aim_started)	
	Events.card_aim_ended.connect(on_card_drag_or_aim_ended)
	Events.card_drag_ended.connect(on_card_drag_or_aim_ended)
	self.card_state_machine.init(self)
	
func set_card(value: CardResource) -> void:
	if not self.is_node_ready():
		await self.ready
	card = value
	self.cost.text = str(value.cost)
	self.icon.texture = value.icon
	
func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func play() -> void:
	if not self.card:
		return
	card.play(self.targets, self.character_stats)
	self.queue_free()

func _input(event: InputEvent) -> void:
	self.card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	self.card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	self.card_state_machine.on_mouse_entered()
	
func _on_mouse_exited() -> void:
	self.card_state_machine.on_mouse_exited()

func _on_drop_detector_area_entered(area: Area2D) -> void:
	if not self.targets.has(area):
		targets.append(area)

func _on_drop_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)

func set_playable(value: bool) -> void:
	playable = value
	if not value:
		cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1, 1, 1, 0.5)
	else:
		cost.remove_theme_color_override("font_color")
		icon.modulate = Color(1, 1, 1, 1)
		
func set_character_stats(value: CharacterStats) -> void:
	character_stats = value
	if not value.stats_changed.is_connected(on_character_stats_changed):
		value.stats_changed.connect(on_character_stats_changed)

func on_character_stats_changed() -> void:
	self.playable = self.character_stats.can_play_card(self.card)

func on_card_drag_or_aim_started(dragged_card: Card) -> void:
	if dragged_card != self:
		self.disabled = true

func on_card_drag_or_aim_ended(_dragged_card: Card) -> void:
	self.disabled = false
	self.playable = self.character_stats.can_play_card(self.card)

func can_interact() -> bool:
	return self.playable and not self.disabled
