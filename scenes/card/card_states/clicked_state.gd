extends CardState

func enter() -> void:
	self.card.drop_point_detector.monitoring = true
	self.card.original_index = self.card.get_index()

func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
