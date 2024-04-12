class_name CardStateMachine
extends Node

@export var initial_state: CardState

var current_state: CardState
var states := {}

func init(card: Card) -> void:
	for child in get_children():
		if child is CardState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.card = card

	if initial_state:
		initial_state.enter()
		self.current_state = initial_state

func on_input(event: InputEvent) -> void:
	if self.current_state:
		self.current_state.on_input(event)

func on_gui_input(event: InputEvent) -> void:
	if self.current_state:
		self.current_state.on_gui_input(event)

func on_mouse_entered() -> void:
	if self.current_state:
		self.current_state.on_mouse_entered()

func on_mouse_exited() -> void:
	if self.current_state:
		self.current_state.on_mouse_exited()

func _on_transition_requested(from: CardState, to: CardState.State) -> void:
	if from != self.current_state:
		return  # Change to assert

	var new_state: CardState = states[to]
	if not new_state:
		return  # Change to assert

	if self.current_state:
		self.current_state.exit()
	new_state.enter()
	self.current_state = new_state
