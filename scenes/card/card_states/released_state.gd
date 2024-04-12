extends CardState

var played: bool

func enter() -> void:
	self.card.color.color = Color.DARK_VIOLET
	self.card.state.text = "RELEASED"
	self.played = false
	
	if not self.card.targets.is_empty():
		self.played = true

func on_input(_event: InputEvent) -> void:
	if self.played:
		return
		
	transition_requested.emit(self, CardState.State.BASE)
