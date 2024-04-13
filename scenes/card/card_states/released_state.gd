extends CardState

var played: bool

func enter() -> void:
	self.played = false
	
	if not self.card.targets.is_empty():
		self.played = true
		self.card.play()

func on_input(_event: InputEvent) -> void:
	if self.played:
		return
		
	transition_requested.emit(self, CardState.State.BASE)
