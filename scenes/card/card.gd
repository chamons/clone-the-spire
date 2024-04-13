class_name Card
extends Control

signal reparent_requested(card: Card)

@export var card: CardResource

@onready var color: ColorRect = $Color
@onready var state: Label = $State
@onready var drop_point_detector: Area2D = $DropDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets : Array[Node] = []

var parent: Control
var tween: Tween

func _ready() -> void:
	self.card_state_machine.init(self)
	
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
