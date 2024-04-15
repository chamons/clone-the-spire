# meta-name: Enemy Action
# meta-description: An action an enemy can take

extends EnemyAction

func perform_action() -> void:
	if not enemy or not target:
		return
	await get_tree().create_timer(0.1, false).timeout
