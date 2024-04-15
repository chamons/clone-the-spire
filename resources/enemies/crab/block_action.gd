extends EnemyAction

@export var block := 6

func perform_action() -> void:
	if not self.enemy or not self.target:
		return
	
	var effect := BlockEffect.new()
	effect.amount = self.block
	effect.sound = sound
	await effect.execute([enemy])
	
	await get_tree().create_timer(0.6, false).timeout
