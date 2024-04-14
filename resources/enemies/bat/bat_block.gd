extends EnemyAction

@export var block := 4

func perform_action() -> void:
	if not enemy or not target:
		return

	var effect := BlockEffect.new()
	effect.amount = self.block
	effect.sound = sound
	effect.execute([enemy])
	
	get_tree().create_timer(0.6, false).timeout.connect(func(): Events.enemy_action_completed.emit(enemy))
