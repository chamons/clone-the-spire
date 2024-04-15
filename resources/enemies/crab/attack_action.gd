extends EnemyAction

@export var damage := 7

func perform_action() -> void:
	if not self.enemy or not self.target:
		return
	
	var damage_effect := DamageEffect.new()
	damage_effect.amount = self.damage
	damage_effect.sound = sound
	var target_array: Array[Node] = [target]
	
	await move_in_front_of_player()	
	await damage_effect.execute(target_array)
	await move_back_to_position()
