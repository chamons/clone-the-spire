extends CardState

func enter() -> void:
	if not card.is_node_ready():
		await card.ready

	if card.tween and card.tween.is_running():
		card.tween.kill()

	self.card.reparent_requested.emit(card)
	self.card.pivot_offset = Vector2.ZERO
	self.card.panel.set("theme_override_styles/panel", card.BASE_STYLEBOX)
	Events.card_tooltip_hide_requested.emit()

func on_gui_input(event: InputEvent) -> void:
	if not self.card.can_interact():
		return

	if event.is_action_pressed("left_mouse"):
		self.card.pivot_offset = card.get_global_mouse_position() - card.global_position
		transition_requested.emit(self, CardState.State.CLICKED)

func on_mouse_entered() -> void:
	if not self.card.can_interact():
		return

	self.card.panel.set("theme_override_styles/panel", card.HOVER_STYLEBOX)
	Events.card_tooltip_requested.emit(self.card)
	
func on_mouse_exited() -> void:
	if not self.card.can_interact():
		return

	self.card.panel.set("theme_override_styles/panel", card.BASE_STYLEBOX)
	Events.card_tooltip_hide_requested.emit()
