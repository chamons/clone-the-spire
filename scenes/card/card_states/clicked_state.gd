extends CardState

func enter() -> void:
	self.card.color.color = Color.ORANGE
	self.card.state.text = "CLICKED"
	self.card.drop_point_detector.monitoring = true

func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
