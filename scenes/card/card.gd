class_name Card
extends Control

signal reparent_requested(card: Card)

const BASE_STYLEBOX := preload("res://scenes/card/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scenes/card/card_dragging_style_box.tres")
const HOVER_STYLEBOX := preload("res://scenes/card/card_hover_stylebox.tres")

@export var card: CardResource : set = set_card

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon

@onready var drop_point_detector: Area2D = $DropDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets : Array[Node] = []

var parent: Control
var tween: Tween

func _ready() -> void:
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
