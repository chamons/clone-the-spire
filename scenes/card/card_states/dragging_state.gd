extends CardState

const DRAG_MINIMUM_THRESHOLD := 0.05
var minimum_drag_elapsed := false

func enter() -> void:
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer: # Change to assert
		self.card.reparent(ui_layer)

	self.minimum_drag_elapsed = false
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func(): self.minimum_drag_elapsed = true)
	self.card.panel.set("theme_override_styles/panel", card.DRAG_STYLEBOX)

func on_input(event: InputEvent) -> void:
	var single_targeted := card.card.is_single_target()
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	if single_targeted and mouse_motion and card.targets.size() > 0:

		transition_requested.emit(self, CardState.State.AIMING)
		return

	if mouse_motion:
		self.card.global_position = card.get_global_mouse_position() - card.pivot_offset

	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif self.minimum_drag_elapsed and confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
