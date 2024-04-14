extends EnemyAction

@export var damage := 7

func perform_action() -> void:
	if not self.enemy or not self.target:
		return
	
	var tween := self.create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 32
	var damage_effect := DamageEffect.new()
	damage_effect.amount = self.damage
	var target_array: Array[Node] = [target]

	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_callback(damage_effect.execute.bind(target_array))
	tween.tween_interval(0.25)
	tween.tween_property(enemy, "global_position", start, 0.4)
	
	tween.finished.connect(func(): Events.enemy_action_completed.emit(enemy))
